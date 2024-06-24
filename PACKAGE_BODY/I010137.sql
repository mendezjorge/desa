
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010137" is

  type r_parameter is record(
    
    p_codi_base             varchar2(100) := pack_repl.fa_devu_codi_base,
    p_indi_most_mens_sali   varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    p_codi_banc_depo_suel_1 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_banc_depo_suel_1'))),
    p_codi_banc_depo_suel_2 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_banc_depo_suel_2')))
    --  p_mask_ceco                  varchar2(100):= fp_ceco_mascara
    
    );

  parameter r_parameter;

  type r_bcab is record(
    
    empl_grup_sang           varchar2(300),
    empl_codi_alte           varchar2(300),
    empl_indi_cobr_cheq      varchar2(300),
    empl_esta                varchar2(300),
    empl_dire                varchar2(300),
    empl_nume_cuen           varchar2(300),
    empl_mail                varchar2(300),
    empl_indi_excl_liqu      varchar2(300),
    empl_codi                varchar2(300),
    empl_tele                varchar2(300),
    empl_nume_cuen_comp      varchar2(300),
    empl_desc                varchar2(300),
    empl_base                varchar2(300),
    empl_nro_ips             varchar2(300),
    empl_cost_hora           varchar2(300),
    empl_val_otr_prof        varchar2(300),
    empl_clave_marc          varchar2(300),
    empl_banc_codi_cuen      varchar2(300),
    empl_val_niv_est         varchar2(300),
    empl_fec_ent_ips         varchar2(300),
    empl_cant_vale_sald      varchar2(300),
    empl_tido_codi           varchar2(300),
    empl_cara                varchar2(300),
    empl_val_nac             varchar2(300),
    empl_fec_ent_mjt         varchar2(300),
    empl_banc_codi_cuen_comp varchar2(300),
    empl_cedu_nume           varchar2(300),
    empl_val_sexo            varchar2(300),
    empl_fec_sal_ips         varchar2(300),
    empl_ceco_codi           varchar2(300),
    empl_fech_naci           varchar2(300),
    empl_sucu_codi           varchar2(300),
    empl_fec_sal_mjt         varchar2(300),
    empl_luga_naci           varchar2(300),
    empl_gest_codi           varchar2(300),
    empl_cage_codi           varchar2(300),
    empl_user_regi           varchar2(300),
    empl_fech_ingr           date,
    empl_fech_regi           varchar2(300),
    empl_sup_inm             varchar2(300),
    empl_fech_baja           date,
    empl_user_modi           varchar2(300),
    empl_val_cargo           varchar2(300),
    empl_fech_modi           varchar2(300),
    empl_val_est_ips         varchar2(300),
    empl_val_cat_mjt         varchar2(300),
    empl_suel_mone_codi      varchar2(300),
    empl_cod_reloj           varchar2(300),
    empl_obse                varchar2(300),
    empl_sala_actu           varchar2(300),
    empl_sala_actu_compl     varchar2(300),
    empl_cost_hora_mmee      varchar2(300),
    empl_emse_codi           varchar2(300),
    empl_tili_codi           varchar2(300),
    empl_plsu_codi           varchar2(300),
    empl_tipe_codi           varchar2(300),
    empl_porc_hora_extr_manu varchar2(300),
    empl_tipo_empl           varchar2(300),
    empl_clpr_codi           varchar2(300),
    empl_secu_presu          varchar2(300),
    empl_inic_presu          varchar2(300),
    empl_dom_otr_prof        varchar2(300),
    empl_dom_niv_est         varchar2(300),
    empl_dom_nac             varchar2(300),
    empl_foto                varchar2(300),
    empl_dom_tip_empl        varchar2(300),
    empl_dom_sexo            varchar2(300),
    empl_lib_legal           varchar2(300),
    empl_hs_extr             varchar2(300),
    empl_aporta_ips          varchar2(300),
    empl_calc_ips            varchar2(300),
    empl_iva                 varchar2(300),
    empl_aso                 varchar2(300),
    empl_deb_cre             varchar2(300),
    empl_marc_hor            varchar2(300),
    empl_regi                varchar2(300),
    empl_empr_codi           varchar2(300),
    empl_dom_cargo           varchar2(300),
    empl_dom_est_ips         varchar2(300),
    empl_cod_hora            varchar2(300),
    empl_dom_cat_mjt         varchar2(300),
    empl_hora_fech_vige      varchar2(300),
    empl_hora_rota           varchar2(300),
    empl_porc_comi           varchar2(300),
    empl_porc_comi_gcia      varchar2(300),
    empl_kilo_reco_chof      varchar2(300),
    empl_hora_reco_chof      varchar2(300),
    empl_fech_venc_habi      varchar2(300),
    empl_nume_habi           varchar2(300),
    empl_obse_chof           varchar2(300),
    empl_maxi_porc_deto      varchar2(300),
    empl_imag                varchar2(300),
    empl_maxi_plaz_cobr      varchar2(300),
    empl_cont_supe           varchar2(300),
    empl_turn_codi           varchar2(300),
    empl_list_codi           varchar2(300),
    empl_cant_plan_pend      varchar2(300),
    empl_codi_empl_refe      varchar2(300),
    empl_firma_elect         blob,
    empl_organigrama         varchar2(300),
    empl_id_files_archivo    varchar2(300),
    empl_nomb_equi           varchar2(300),
    empl_nomb_abre           varchar2(300),
    empl_nro_corporativo     varchar2(300),
    empl_orde_dist_recl_cli  varchar2(300),
    empl_codi_wolkvox        number,
    empl_codi_bitrix         number);
  bcab r_bcab;

  procedure pp_dire_actualizar(p_emdir_empl_cod    in varchar2,
                               p_emdir_cod         in varchar2,
                               p_emdir_desc        in varchar2,
                               p_emdir_nro_casa    in varchar2,
                               p_emdir_pais        in varchar2,
                               p_emdir_depa        in varchar2,
                               p_emdir_ciud        in varchar2,
                               p_emdir_barr        in varchar2,
                               p_emdir_correo      in varchar2,
                               p_emdir_cod_postal  in varchar2,
                               p_emdir_dom_tip_viv in varchar2,
                               p_emdir_val_tip_viv in varchar2,
                               p_emdir_dir_princ   in varchar2,
                               p_opcion            in varchar2) is
  
  begin
    --raise_application_error(-20001, p_opcion);
    if p_opcion = 'CREATE' then
    
      insert into come_empl_dir
        (emdir_empl_cod,
         emdir_cod,
         emdir_desc,
         emdir_nro_casa,
         emdir_pais,
         emdir_depa,
         emdir_ciud,
         emdir_barr,
         emdir_correo,
         emdir_cod_postal,
         emdir_dom_tip_viv,
         emdir_val_tip_viv,
         emdir_dir_princ)
      values
        (p_emdir_empl_cod,
         p_emdir_cod,
         p_emdir_desc,
         p_emdir_nro_casa,
         p_emdir_pais,
         p_emdir_depa,
         p_emdir_ciud,
         p_emdir_barr,
         p_emdir_correo,
         p_emdir_cod_postal,
         p_emdir_dom_tip_viv,
         p_emdir_val_tip_viv,
         p_emdir_dir_princ);
    
    elsif p_opcion = 'SAVE' then
      update come_empl_dir
         set emdir_desc        = p_emdir_desc,
             emdir_nro_casa    = p_emdir_nro_casa,
             emdir_pais        = p_emdir_pais,
             emdir_depa        = p_emdir_depa,
             emdir_ciud        = p_emdir_ciud,
             emdir_barr        = p_emdir_barr,
             emdir_correo      = p_emdir_correo,
             emdir_cod_postal  = p_emdir_cod_postal,
             emdir_dom_tip_viv = p_emdir_dom_tip_viv,
             emdir_val_tip_viv = p_emdir_val_tip_viv,
             emdir_dir_princ   = p_emdir_dir_princ
       where emdir_empl_cod = p_emdir_empl_cod
         and emdir_cod = p_emdir_cod;
    
    elsif p_opcion = 'DELETE' then
    
      delete come_empl_dir
       where emdir_empl_cod = p_emdir_empl_cod
         and emdir_cod = p_emdir_cod;
    
    end if;
  end pp_dire_actualizar;

  procedure pp_tele_actualizar(p_emtel_empl_cod    in varchar2,
                               p_emtel_item        in varchar2,
                               p_emtel_area        in varchar2,
                               p_emtel_nro_tel     in varchar2,
                               p_emdir_dom_tip_tel in varchar2,
                               p_emtel_val_tip     in varchar2,
                               p_emdir_dom_ubic    in varchar2,
                               p_emtel_val_ubic    in varchar2,
                               p_emtel_int         in varchar2,
                               p_emtel_nota        in varchar2,
                               p_emtel_princ       in varchar2,
                               p_opcion            in varchar2) is
    v_item number;
  begin
    -- raise_application_error(-20001, p_opcion);
    if p_opcion = 'CREATE' then
      select nvl(max(emtel_item), 0) + 1
        into v_item
        from come_empl_tel
       where emtel_empl_cod = P_emtel_empl_cod;
    
      insert into come_empl_tel
        (emtel_empl_cod,
         emtel_item,
         emtel_area,
         emtel_nro_tel,
         emdir_dom_tip_tel,
         emtel_val_tip,
         emdir_dom_ubic,
         emtel_val_ubic,
         emtel_int,
         emtel_nota,
         emtel_princ)
      values
        (p_emtel_empl_cod,
         v_item,
         p_emtel_area,
         p_emtel_nro_tel,
         p_emdir_dom_tip_tel,
         p_emtel_val_tip,
         p_emdir_dom_ubic,
         p_emtel_val_ubic,
         p_emtel_int,
         p_emtel_nota,
         p_emtel_princ);
    elsif p_opcion = 'SAVE' then
    
      update come_empl_tel
         set emtel_area        = p_emtel_area,
             emtel_nro_tel     = p_emtel_nro_tel,
             emdir_dom_tip_tel = p_emdir_dom_tip_tel,
             emtel_val_tip     = p_emtel_val_tip,
             emdir_dom_ubic    = p_emdir_dom_ubic,
             emtel_val_ubic    = p_emtel_val_ubic,
             emtel_int         = p_emtel_int,
             emtel_nota        = p_emtel_nota,
             emtel_princ       = p_emtel_princ
       where emtel_empl_cod = p_emtel_empl_cod
         and emtel_item = p_emtel_item;
    elsif p_opcion = 'DELETE' then
      delete come_empl_tel
       where emtel_empl_cod = p_emtel_empl_cod
         and emtel_item = p_emtel_item;
    end if;
  end pp_tele_actualizar;

  procedure pp_iden_actualizar(p_emid_empl_cod in varchar2,
                               p_emid_item     in varchar2,
                               p_emid_tipo     in varchar2,
                               p_emid_nro      in varchar2,
                               p_emid_fec_vto  in varchar2,
                               p_opcion        in varchar2) is
    v_emid_item number;
  begin
  
    -- raise_application_error(-20001, bcab.empl_codi);
    if p_opcion = 'CREATE' then
      select nvl(max(emid_item), 0) + 1
        into v_emid_item
        from come_empl_ident
       where emid_empl_cod = p_emid_empl_cod;
    
      insert into come_empl_ident
        (emid_empl_cod, emid_item, emid_tipo, emid_nro, emid_fec_vto)
      values
        (p_emid_empl_cod,
         v_emid_item,
         p_emid_tipo,
         p_emid_nro,
         p_emid_fec_vto);
    elsif p_opcion = 'SAVE' then
      update come_empl_ident
         set emid_empl_cod = p_emid_empl_cod,
             emid_item     = p_emid_item,
             emid_tipo     = p_emid_tipo,
             emid_nro      = p_emid_nro,
             emid_fec_vto  = p_emid_fec_vto
       where emid_empl_cod = p_emid_empl_cod
         and emid_item = p_emid_item;
    elsif p_opcion = 'DELETE' then
      delete come_empl_ident
       where emid_empl_cod = P_emid_empl_cod
         and emid_item = P_emid_item;
    end if;
  end pp_iden_actualizar;

  procedure pp_fami_actualizar(p_deta_empl_codi   in varchar2,
                               p_deta_nume_item   in varchar2,
                               p_deta_fami_codi   in varchar2,
                               p_deta_nomb_fami   in varchar2,
                               p_deta_fech_naci   in date,
                               p_deta_indi_boni   in varchar2,
                               p_deta_sexo        in varchar2,
                               p_deta_base        in varchar2,
                               p_deta_dom_niv_est in varchar2,
                               p_deta_niv_est     in varchar2,
                               p_deta_obs         in varchar2,
                               p_opcion           in varchar2) is
    v_deta_nume_item number;
  begin
  
    if p_opcion in ('CREATE', 'SAVE') then
    
      update come_empl_fami_deta
         set deta_empl_codi   = p_deta_empl_codi,
             deta_nume_item   = p_deta_nume_item,
             deta_fami_codi   = p_deta_fami_codi,
             deta_nomb_fami   = p_deta_nomb_fami,
             deta_fech_naci   = p_deta_fech_naci,
             deta_indi_boni   = p_deta_indi_boni,
             deta_sexo        = p_deta_sexo,
             deta_base        = p_deta_base,
             deta_dom_niv_est = p_deta_dom_niv_est,
             deta_niv_est     = p_deta_niv_est,
             deta_obs         = p_deta_obs
       where deta_empl_codi = p_deta_empl_codi
         and deta_nume_item = p_deta_nume_item;
    
      if sql%notfound then
        select nvl(max(deta_nume_item), 0) + 1
          into v_deta_nume_item
          from come_empl_fami_deta
         where deta_empl_codi = p_deta_empl_codi;
      
        insert into come_empl_fami_deta
          (deta_empl_codi,
           deta_nume_item,
           deta_fami_codi,
           deta_nomb_fami,
           deta_fech_naci,
           deta_indi_boni,
           deta_sexo,
           deta_base,
           deta_dom_niv_est,
           deta_niv_est,
           deta_obs)
        values
          (p_deta_empl_codi,
           v_deta_nume_item,
           p_deta_fami_codi,
           p_deta_nomb_fami,
           p_deta_fech_naci,
           p_deta_indi_boni,
           p_deta_sexo,
           p_deta_base,
           p_deta_dom_niv_est,
           p_deta_niv_est,
           p_deta_obs);
      end if;
      --   RAISE_APPLICATION_ERROR(-20001,'DDF');
      /*elsif p_opcion = 'SAVE' then
        update come_empl_fami_deta
           set deta_empl_codi   = p_deta_empl_codi,
               deta_nume_item   = p_deta_nume_item,
               deta_fami_codi   = p_deta_fami_codi,
               deta_nomb_fami   = p_deta_nomb_fami,
               deta_fech_naci   = p_deta_fech_naci,
               deta_indi_boni   = p_deta_indi_boni,
               deta_sexo        = p_deta_sexo,
               deta_base        = p_deta_base,
               deta_dom_niv_est = p_deta_dom_niv_est,
               deta_niv_est     = p_deta_niv_est,
               deta_obs         = p_deta_obs
         where deta_empl_codi = p_deta_empl_codi
           and deta_nume_item = p_deta_nume_item;
      */
    elsif p_opcion = 'DELETE' then
    
      delete come_empl_fami_deta
       where deta_empl_codi = p_deta_empl_codi
         and deta_nume_item = p_deta_nume_item;
    end if;
  
  end pp_fami_actualizar;

  procedure pp_mostrar_dias(p_dia_nro in number, p_dia_desc out varchar2) is
  begin
    if p_dia_nro = 1 then
      p_dia_desc := 'Lunes';
    elsif p_dia_nro = 2 then
      p_dia_desc := 'Martes';
    elsif p_dia_nro = 3 then
      p_dia_desc := 'Miercoles';
    elsif p_dia_nro = 4 then
      p_dia_desc := 'Jueves';
    elsif p_dia_nro = 5 then
      p_dia_desc := 'Viernes';
    elsif p_dia_nro = 6 then
      p_dia_desc := 'Sabado';
    elsif p_dia_nro = 7 then
      p_dia_desc := 'Domingo';
    end if;
  end pp_mostrar_dias;

  procedure pp_mostrar_turnos(p_empl_turn_codi number) is
  
    cursor c_turnos is
      select t.tude_dia_sema dia,
             t.tude_hor_codi_hora,
             to_char(h.hor_entrada_1, 'hh24:mi') entrada,
             to_char(h.hor_salida_1, 'hh24:mi') salida,
             h.hor_desc
        from rrhh_turn_deta t, rrhh_horario h, rrhh_turn d
       where t.tude_turn_codi = p_empl_turn_codi
         and t.tude_hor_codi_hora = h.hor_codi_hora
         and d.turn_codi = t.tude_turn_codi
       order by 1;
    v_dia_sema_desc varchar2(200);
  
  begin
    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name => 'DETALLE');
    for x in c_turnos loop
    
      pp_mostrar_dias(x.dia, v_dia_sema_desc);
    
      apex_collection.add_member(p_collection_name => 'BDETA_CONS',
                                 p_c001            => x.dia,
                                 p_c002            => x.entrada,
                                 p_c003            => x.salida,
                                 p_c004            => x.hor_desc,
                                 p_c005            => v_dia_sema_desc);
    end loop;
  
  exception
    when no_data_found then
      null;
  end pp_mostrar_turnos;

  procedure pp_valida_perfil(p_empl_codi_alte number,
                             p_empl_empr_codi number) is
  
    v_cant      number;
    v_user_empl number;
  begin
  
    select user_empl_codi
      into v_user_empl
      from segu_user
     where user_login = fp_user;
  
    if v_user_empl is null then
      pl_me('El usuario no tiene empleado relacionado en el mantenimiento de usuario');
    end if;
  
    select count(*)
      into v_cant
      from rrhh_perf p, rrhh_perf_empl pe, come_empl e
     where p.perf_codi = (select u.user_perf_codi
                            from segu_user u
                           where user_login = fp_user)
       and p.perf_codi = pe.peem_perf_codi
       and pe.peem_empl_codi = e.empl_codi
          --cambiado juanb 25/01/2024
       and e.empl_codi_alte = p_empl_codi_alte
          --    (select user_empl_codi from segu_user where user_login = fp_user) --p_empl_codi_alte 
       and e.empl_empr_codi = p_empl_empr_codi;
  
    if v_cant = 0 and fp_user <> 'SKN' then
      raise_application_error(-20001,
                              'El empleado no pertenece a su perfil de empleado asignado.');
    end if;
  
  end pp_valida_perfil;

  procedure pp_set_variables is
    v_archivo blob;
  begin
  
    BCAB.EMPL_VAL_SEXO            := V('P106_EMPL_VAL_SEXO');
    BCAB.EMPL_VAL_OTR_PROF        := V('P106_EMPL_VAL_OTR_PROF');
    BCAB.EMPL_VAL_NIV_EST         := V('P106_EMPL_VAL_NIV_EST');
    BCAB.EMPL_VAL_NAC             := V('P106_EMPL_VAL_NAC');
    BCAB.EMPL_VAL_EST_IPS         := V('P106_EMPL_VAL_EST_IPS');
    BCAB.EMPL_VAL_CAT_MJT         := V('P106_EMPL_VAL_CAT_MJT');
    BCAB.EMPL_VAL_CARGO           := V('P106_EMPL_VAL_CARGO');
    BCAB.EMPL_TURN_CODI           := V('P106_EMPL_TURN_CODI');
    BCAB.EMPL_TIPO_EMPL           := V('P106_EMPL_TIPO_EMPL');
    BCAB.EMPL_TIPE_CODI           := V('P106_EMPL_TIPE_CODI');
    BCAB.EMPL_TILI_CODI           := V('P106_EMPL_TILI_CODI');
    BCAB.EMPL_TIDO_CODI           := V('P106_EMPL_TIDO_CODI');
    BCAB.EMPL_TELE                := V('P106_EMPL_TELE');
    BCAB.EMPL_SUP_INM             := V('P106_EMPL_SUP_INM');
    BCAB.EMPL_SUEL_MONE_CODI      := V('P106_EMPL_SUEL_MONE_CODI');
    BCAB.EMPL_SUCU_CODI           := V('P106_EMPL_SUCU_CODI');
    BCAB.EMPL_SECU_PRESU          := V('P106_EMPL_SECU_PRESU');
    BCAB.EMPL_SALA_ACTU_COMPL     := V('P106_EMPL_SALA_ACTU_COMPL');
    BCAB.EMPL_SALA_ACTU           := V('P106_EMPL_SALA_ACTU');
    BCAB.EMPL_REGI                := NVL(V('P106_EMPL_REGI'), 'L');
    BCAB.EMPL_PORC_HORA_EXTR_MANU := V('P106_EMPL_PORC_HORA_EXTR_MANU');
    BCAB.EMPL_PORC_COMI_GCIA      := V('P106_EMPL_PORC_COMI_GCIA');
    BCAB.EMPL_PORC_COMI           := V('P106_EMPL_PORC_COMI');
    BCAB.EMPL_PLSU_CODI           := V('P106_EMPL_PLSU_CODI');
    BCAB.EMPL_ORGANIGRAMA         := V('P106_EMPL_ORGANIGRAMA');
    BCAB.EMPL_ORDE_DIST_RECL_CLI  := V('P106_EMPL_ORDE_DIST_RECL_CLI');
    BCAB.EMPL_OBSE_CHOF           := V('P106_EMPL_OBSE_CHOF');
    BCAB.EMPL_OBSE                := V('P106_EMPL_OBSE');
    BCAB.EMPL_NUME_HABI           := V('P106_EMPL_NUME_HABI');
    BCAB.EMPL_NUME_CUEN_COMP      := V('P106_EMPL_NUME_CUEN_COMP');
    BCAB.EMPL_NUME_CUEN           := V('P106_EMPL_NUME_CUEN');
    BCAB.EMPL_NRO_IPS             := V('P106_EMPL_NRO_IPS');
    BCAB.EMPL_NRO_CORPORATIVO     := V('P106_EMPL_NRO_CORPORATIVO');
    BCAB.EMPL_NOMB_EQUI           := V('P106_EMPL_NOMB_EQUI');
    BCAB.EMPL_NOMB_ABRE           := V('P106_EMPL_NOMB_ABRE');
    BCAB.EMPL_MAXI_PORC_DETO      := V('P106_EMPL_MAXI_PORC_DETO');
    BCAB.EMPL_MAXI_PLAZ_COBR      := V('P106_EMPL_MAXI_PLAZ_COBR');
    BCAB.EMPL_MARC_HOR            := NVL(V('P106_EMPL_MARC_HOR'), 'N');
    BCAB.EMPL_MAIL                := V('P106_EMPL_MAIL');
    BCAB.EMPL_LUGA_NACI           := V('P106_EMPL_LUGA_NACI');
    BCAB.EMPL_LIST_CODI           := V('P106_EMPL_LIST_CODI');
    BCAB.EMPL_LIB_LEGAL           := NVL(V('P106_EMPL_LIB_LEGAL'), 'N');
    BCAB.EMPL_KILO_RECO_CHOF      := V('P106_EMPL_KILO_RECO_CHOF');
    BCAB.EMPL_IVA                 := NVL(V('P106_EMPL_IVA'), 'N');
    BCAB.EMPL_INIC_PRESU          := V('P106_EMPL_INIC_PRESU');
    BCAB.EMPL_INDI_EXCL_LIQU      := V('P106_EMPL_INDI_EXCL_LIQU');
    BCAB.EMPL_INDI_COBR_CHEQ      := V('P106_EMPL_INDI_COBR_CHEQ');
    BCAB.EMPL_IMAG                := V('P106_EMPL_IMAG');
    BCAB.EMPL_ID_FILES_ARCHIVO    := V('P106_EMPL_ID_FILES_ARCHIVO');
    BCAB.EMPL_HS_EXTR             := NVL(V('P106_EMPL_HS_EXTR'), 'N');
    BCAB.EMPL_HORA_ROTA           := V('P106_EMPL_HORA_ROTA');
    BCAB.EMPL_HORA_RECO_CHOF      := V('P106_EMPL_HORA_RECO_CHOF');
    BCAB.EMPL_HORA_FECH_VIGE      := V('P106_EMPL_HORA_FECH_VIGE');
    BCAB.EMPL_GRUP_SANG           := V('P106_EMPL_GRUP_SANG');
    BCAB.EMPL_GEST_CODI           := V('P106_EMPL_GEST_CODI');
    BCAB.EMPL_FOTO                := V('P106_EMPL_FOTO');
  
    BCAB.EMPL_FEC_SAL_MJT         := V('P106_EMPL_FEC_SAL_MJT');
    BCAB.EMPL_FEC_SAL_IPS         := V('P106_EMPL_FEC_SAL_IPS');
    BCAB.EMPL_FEC_ENT_MJT         := V('P106_EMPL_FEC_ENT_MJT');
    BCAB.EMPL_FEC_ENT_IPS         := V('P106_EMPL_FEC_ENT_IPS');
    BCAB.EMPL_FECH_VENC_HABI      := V('P106_EMPL_FECH_VENC_HABI');
    BCAB.EMPL_FECH_REGI           := V('P106_EMPL_FECH_REGI');
    BCAB.EMPL_FECH_NACI           := V('P106_EMPL_FECH_NACI');
    BCAB.EMPL_FECH_MODI           := V('P106_EMPL_FECH_MODI');
    BCAB.EMPL_FECH_INGR           := V('P106_EMPL_FECH_INGR');
    BCAB.EMPL_FECH_BAJA           := V('P106_EMPL_FECH_BAJA');
    BCAB.EMPL_ESTA                := V('P106_EMPL_ESTA');
    BCAB.EMPL_EMSE_CODI           := V('P106_EMPL_EMSE_CODI');
    BCAB.EMPL_EMPR_CODI           := V('AI_EMPR_CODI'); --cambiado juanb 25/01/2024
    BCAB.EMPL_DIRE                := V('P106_EMPL_DIRE');
    BCAB.EMPL_DESC                := V('P106_EMPL_DESC');
    BCAB.EMPL_DEB_CRE             := NVL(V('P106_EMPL_DEB_CRE'), 'N');
    BCAB.EMPL_COST_HORA_MMEE      := V('P106_EMPL_COST_HORA_MMEE');
    BCAB.EMPL_COST_HORA           := V('P106_EMPL_COST_HORA');
    BCAB.EMPL_CONT_SUPE           := V('P106_EMPL_CONT_SUPE');
    BCAB.EMPL_COD_RELOJ           := V('P106_EMPL_COD_RELOJ');
    BCAB.EMPL_COD_HORA            := V('P106_EMPL_COD_HORA');
    BCAB.EMPL_CODI_EMPL_REFE      := V('P106_EMPL_CODI_EMPL_REFE');
    BCAB.EMPL_CODI_ALTE           := V('P106_EMPL_CODI_ALTE');
    BCAB.EMPL_CODI                := V('P106_EMPL_CODI');
    BCAB.EMPL_CLPR_CODI           := V('P106_EMPL_CLPR_CODI');
    BCAB.EMPL_CLAVE_MARC          := V('P106_EMPL_CLAVE_MARC');
    BCAB.EMPL_CEDU_NUME           := V('P106_EMPL_CEDU_NUME');
    BCAB.EMPL_CECO_CODI           := V('P106_EMPL_CECO_CODI');
    BCAB.EMPL_CARA                := NVL(V('P106_EMPL_CARA'), 'I');
    BCAB.EMPL_CANT_VALE_SALD      := V('P106_EMPL_CANT_VALE_SALD');
    BCAB.EMPL_CANT_PLAN_PEND      := V('P106_EMPL_CANT_PLAN_PEND');
    BCAB.EMPL_CALC_IPS            := NVL(V('P106_EMPL_CALC_IPS'), 'N');
    BCAB.EMPL_CAGE_CODI           := V('P106_EMPL_CAGE_CODI');
    BCAB.EMPL_BASE                := V('P106_EMPL_BASE');
    BCAB.EMPL_BANC_CODI_CUEN_COMP := V('P106_EMPL_BANC_CODI_CUEN_COMP');
    BCAB.EMPL_BANC_CODI_CUEN      := V('P106_EMPL_BANC_CODI_CUEN');
    BCAB.EMPL_ASO                 := NVL(V('P106_EMPL_ASO'), 'N');
    BCAB.EMPL_APORTA_IPS          := NVL(V('P106_EMPL_APORTA_IPS'), 'N');
    bcab.empl_codi_wolkvox        := v('P106_EMPL_CODI_WOLKVOX');
    bcab.empl_codi_bitrix         := v('P106_EMPL_CODI_BITRIX');
  
    begin
      select blob_content --, mime_type, filename
        into v_archivo --, v_mime_type, v_filename
        from APEX_APPLICATION_FILES A
       where A.NAME = V('P106_EMPL_FIRMA_ELECT')
         and ROWNUM = 1;
    exception
      when others then
        null;
    end;
    BCAB.EMPL_FIRMA_ELECT := v_archivo;
  end pp_set_variables;

  procedure pp_actualizar(p_opcion in varchar2) is
  
    cursor iden is
      select to_number(c001) emid_empl_cod,
             to_number(c002) emid_item,
             c003 Tipo,
             c004 Numero,
             to_date(c005) Vencimiento,
             c006 oper,
             seq_id
        from apex_collections
       where collection_name = 'IDENTIFICACIONES'
         and c006 is not null;
  
    cursor tele is
      select to_number(c001) emtel_empl_cod,
             to_number(c002) emtel_item,
             c003 emtel_area,
             c004 emtel_nro_tel,
             c005 emdir_dom_tip_tel,
             c006 emtel_val_tip,
             c007 emdir_dom_ubic,
             c008 emtel_val_ubic,
             c009 emtel_int,
             c010 emtel_nota,
             c011 emtel_princ,
             decode(c011, 'S', 'Si', 'No') Principal,
             c012 opcion,
             seq_id
        from apex_collections
       where collection_name = 'TELEFONO'
         and c012 is not null;
  
    cursor dire is
      select c001 emdir_empl_cod,
             c002 emdir_cod,
             c003 emdir_desc,
             c004 emdir_nro_casa,
             c005 emdir_pais,
             c006 emdir_depa,
             c007 emdir_ciud,
             c008 emdir_barr,
             c009 emdir_correo,
             c010 emdir_cod_postal,
             c011 emdir_dom_tip_viv,
             c012 emdir_val_tip_viv,
             c013 emdir_dir_princ,
             c014 opcion
        from apex_collections
       where collection_name = 'DIRECCION'
         and c014 is not null;
  
    cursor FAMI is
      select c001   deta_empl_codi,
             c002   deta_nume_item,
             c003   deta_fami_codi,
             c004   deta_nomb_fami,
             c005   deta_fech_naci,
             c006   deta_indi_boni,
             c007   deta_sexo,
             c008   deta_base,
             c009   deta_dom_niv_est,
             c010   deta_niv_est,
             c011   deta_obs,
             c012   edad,
             c013   opcion,
             seq_id
        from apex_collections
       where collection_name = 'FAMILIA'
         and C003 is not null;
  
    v_empl_codi_alte    number;
    v_empl_codi         number;
    v_empl_dom_tip_empl varchar2(60);
    v_empl_dom_sexo     varchar2(60);
    v_empl_dom_cargo    varchar2(60);
    v_empl_dom_otr_prof varchar2(60);
    v_empl_dom_niv_est  varchar2(60);
    v_empl_dom_nac      varchar2(60);
    v_empl_dom_est_ips  varchar2(60);
    v_empl_dom_cat_mjt  varchar2(60);
    v_archivo           blob;
  
  begin
  
    pp_set_variables;
    pp_valida_perfil(bcab.empl_codi_alte, bcab.empl_empr_codi);
  
    if bcab.empl_plsu_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar la plantilla para liq. de sueldos');
    end if;
  
    if bcab.empl_cod_reloj is not null then
      I010137.pp_validar_reloj(p_empl_cod_reloj => bcab.empl_cod_reloj);
    end if;
  
    if bcab.empl_tipo_empl is null then
      raise_application_error(-20001, 'Debe ingresar tipo de empleado');
    end if;
  
    if bcab.empl_plsu_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar la plantilla para liq. de sueldos');
    end if;
  
    if bcab.empl_banc_codi_cuen is null then
      i010137.pp_veri_cuen_banc(p_cuen_codi => bcab.empl_banc_codi_cuen);
    end if;
  
    if bcab.empl_banc_codi_cuen_comp is null then
      i010137.pp_veri_cuen_banc(p_cuen_codi => bcab.empl_banc_codi_cuen_comp);
    end if;
  
    if nvl(bcab.empl_cost_hora, 0) < 0 then
      raise_application_error(-20001,
                              'El costo x hora del empleado no puede ser menor a Cero');
    end if;
    if bcab.empl_tili_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar el Codigo del Tipo de liquidaci?n');
    end if;
    if nvl(bcab.empl_sala_actu, 0) < 0 then
      raise_application_error(-20001,
                              'El salario del empleado no puede ser menor a Cero');
    end if;
    if nvl(bcab.empl_sala_actu_compl, 0) < 0 then
      raise_application_error(-20001,
                              'El salario del empleado no puede ser menor a Cero');
    end if;
  
    if bcab.empl_fech_baja < bcab.empl_fech_ingr then
      raise_application_error(-20001,
                              'La fecha de Egreso no puede ser menor a la Fecha de Ingreso');
    end if;
  
    if bcab.empl_fech_naci >= sysdate then
      raise_application_error(-20001,
                              'La fecha de nacimiento no puede ser mayor o igual a la fecha actual');
    end if;
  
    bcab.empl_base := parameter.p_codi_base;
  
    bcab.empl_cara := 'I';
  
    if bcab.EMPL_VAL_OTR_PROF is not null then
    
      bcab.EMPL_DOM_OTR_PROF := 'TIP_PROFESION';
    end if;
  
    if bcab.EMPL_VAL_NIV_EST is not null then
      bcab.EMPL_DOM_NIV_EST := 'NIV_ESTUDIO';
    end if;
    --
    if bcab.EMPL_VAL_NAC is not null then
      bcab.EMPL_DOM_NAC := 'NACIONALIDAD';
    end if;
    --
    if bcab.EMPL_TIPO_EMPL is not null then
      bcab.EMPL_DOM_TIP_EMPL := 'TIP_EMPLEADO';
    end if;
    --
    if bcab.EMPL_VAL_SEXO is not null then
      bcab.EMPL_DOM_SEXO := 'SEXO';
    end if;
    --
    if bcab.EMPL_VAL_CARGO is not null then
      bcab.EMPL_DOM_CARGO := 'TIP_CARGO';
    end if;
    --
    if bcab.EMPL_VAL_EST_IPS is not null then
      bcab.EMPL_DOM_EST_IPS := 'EST_IPS';
    end if;
    --
    if bcab.empl_val_cat_mjt is not null then
      bcab.EMPL_DOM_CAT_MJT := 'CAT_EMPL_MJT';
    end if;
  
    if bcab.empl_esta = 'I' and BCAB.empl_fech_baja is null then
      raise_application_error(-20001,
                              'La fecha de baja no puede ser nulo al inactivar el empleado');
    
    end if;
  
    --raise_application_Error(-20001,BCAB.EMPL_REGI );
  
    if p_opcion = 'CREATE' then
    
      select NVL(max(empl_codi), 0) + 1 into v_empl_codi from come_empl;
    
      select nvl(max(to_number(e.empl_codi_alte)), 0) + 1
        into v_empl_codi_alte
        from come_empl e
       where e.empl_empr_codi = bcab.empl_empr_codi;
    
      bcab.empl_codi := v_empl_codi;
    
      insert into come_empl
        (empl_codi,
         empl_desc,
         empl_esta,
         empl_base,
         empl_cost_hora,
         empl_tido_codi,
         empl_cara,
         empl_clpr_codi,
         empl_emse_codi,
         empl_cedu_nume,
         empl_dire,
         empl_fech_ingr,
         empl_fech_baja,
         empl_sala_actu,
         empl_mail,
         empl_tele,
         empl_obse,
         empl_fech_naci,
         empl_luga_naci,
         empl_grup_sang,
         empl_cost_hora_mmee,
         empl_suel_mone_codi,
         empl_tili_codi,
         empl_tipe_codi,
         empl_porc_hora_extr_manu,
         empl_sucu_codi,
         empl_tipo_empl,
         empl_cage_codi,
         empl_gest_codi,
         empl_nume_cuen,
         empl_banc_codi_cuen,
         empl_indi_excl_liqu,
         empl_secu_presu,
         empl_inic_presu,
         empl_dom_otr_prof,
         empl_val_otr_prof,
         empl_dom_niv_est,
         empl_val_niv_est,
         empl_dom_nac,
         empl_val_nac,
         empl_foto,
         empl_dom_tip_empl,
         empl_dom_sexo,
         empl_val_sexo,
         empl_lib_legal,
         empl_hs_extr,
         empl_aporta_ips,
         empl_calc_ips,
         empl_iva,
         empl_aso,
         empl_deb_cre,
         empl_marc_hor,
         empl_regi,
         empl_user_regi,
         empl_fech_regi,
         --empl_user_modi,
         --empl_fech_modi,
         empl_codi_alte,
         empl_empr_codi,
         empl_val_est_ips,
         empl_val_cargo,
         empl_dom_cargo,
         empl_dom_est_ips,
         empl_nro_ips,
         empl_clave_marc,
         empl_fec_ent_ips,
         empl_fec_ent_mjt,
         empl_fec_sal_ips,
         empl_fec_sal_mjt,
         empl_sup_inm,
         empl_cod_hora,
         empl_dom_cat_mjt,
         empl_val_cat_mjt,
         empl_cod_reloj,
         empl_hora_fech_vige,
         empl_hora_rota,
         empl_porc_comi,
         empl_porc_comi_gcia,
         empl_kilo_reco_chof,
         empl_hora_reco_chof,
         empl_fech_venc_habi,
         empl_nume_habi,
         empl_obse_chof,
         empl_maxi_porc_deto,
         empl_sala_actu_compl,
         empl_imag,
         empl_maxi_plaz_cobr,
         empl_ceco_codi,
         empl_cont_supe,
         empl_cant_vale_sald,
         empl_turn_codi,
         empl_plsu_codi,
         empl_list_codi,
         empl_cant_plan_pend,
         empl_banc_codi_cuen_comp,
         empl_nume_cuen_comp,
         empl_indi_cobr_cheq,
         empl_codi_empl_refe,
         empl_firma_elect,
         empl_organigrama,
         empl_id_files_archivo,
         empl_nomb_equi,
         empl_nomb_abre,
         empl_nro_corporativo,
         empl_orde_dist_recl_cli)
      values
        (v_empl_codi,
         bcab.empl_desc,
         bcab.empl_esta,
         bcab.empl_base,
         bcab.empl_cost_hora,
         bcab.empl_tido_codi,
         bcab.empl_cara,
         bcab.empl_clpr_codi,
         bcab.empl_emse_codi,
         bcab.empl_cedu_nume,
         bcab.empl_dire,
         bcab.empl_fech_ingr,
         bcab.empl_fech_baja,
         bcab.empl_sala_actu,
         bcab.empl_mail,
         bcab.empl_tele,
         bcab.empl_obse,
         bcab.empl_fech_naci,
         bcab.empl_luga_naci,
         bcab.empl_grup_sang,
         bcab.empl_cost_hora_mmee,
         bcab.empl_suel_mone_codi,
         bcab.empl_tili_codi,
         bcab.empl_tipe_codi,
         bcab.empl_porc_hora_extr_manu,
         bcab.empl_sucu_codi,
         bcab.empl_tipo_empl,
         bcab.empl_cage_codi,
         bcab.empl_gest_codi,
         bcab.empl_nume_cuen,
         bcab.empl_banc_codi_cuen,
         bcab.empl_indi_excl_liqu,
         bcab.empl_secu_presu,
         bcab.empl_inic_presu,
         bcab.empl_dom_otr_prof,
         bcab.empl_val_otr_prof,
         bcab.empl_dom_niv_est,
         bcab.empl_val_niv_est,
         bcab.empl_dom_nac,
         bcab.empl_val_nac,
         bcab.empl_foto,
         bcab.empl_dom_tip_empl,
         bcab.empl_dom_sexo,
         bcab.empl_val_sexo,
         bcab.empl_lib_legal,
         bcab.empl_hs_extr,
         bcab.empl_aporta_ips,
         bcab.empl_calc_ips,
         bcab.empl_iva,
         bcab.empl_aso,
         bcab.empl_deb_cre,
         bcab.empl_marc_hor,
         bcab.empl_regi,
         fp_user,
         sysdate,
         --  bcab.empl_user_modi,
         --  bcab.empl_fech_modi,
         bcab.empl_codi_alte,
         bcab.empl_empr_codi,
         bcab.empl_val_est_ips,
         bcab.empl_val_cargo,
         bcab.empl_dom_cargo,
         bcab.empl_dom_est_ips,
         bcab.empl_nro_ips,
         bcab.empl_clave_marc,
         bcab.empl_fec_ent_ips,
         bcab.empl_fec_ent_mjt,
         bcab.empl_fec_sal_ips,
         bcab.empl_fec_sal_mjt,
         bcab.empl_sup_inm,
         bcab.empl_cod_hora,
         bcab.empl_dom_cat_mjt,
         bcab.empl_val_cat_mjt,
         bcab.empl_cod_reloj,
         bcab.empl_hora_fech_vige,
         bcab.empl_hora_rota,
         bcab.empl_porc_comi,
         bcab.empl_porc_comi_gcia,
         bcab.empl_kilo_reco_chof,
         bcab.empl_hora_reco_chof,
         bcab.empl_fech_venc_habi,
         bcab.empl_nume_habi,
         bcab.empl_obse_chof,
         bcab.empl_maxi_porc_deto,
         bcab.empl_sala_actu_compl,
         bcab.empl_imag,
         bcab.empl_maxi_plaz_cobr,
         bcab.empl_ceco_codi,
         bcab.empl_cont_supe,
         bcab.empl_cant_vale_sald,
         bcab.empl_turn_codi,
         bcab.empl_plsu_codi,
         bcab.empl_list_codi,
         bcab.empl_cant_plan_pend,
         bcab.empl_banc_codi_cuen_comp,
         bcab.empl_nume_cuen_comp,
         bcab.empl_indi_cobr_cheq,
         bcab.empl_codi_empl_refe,
         bcab.empl_firma_elect,
         bcab.empl_organigrama,
         bcab.empl_id_files_archivo,
         bcab.empl_nomb_equi,
         bcab.empl_nomb_abre,
         bcab.empl_nro_corporativo,
         bcab.empl_orde_dist_recl_cli);
    
    elsif p_opcion = 'SAVE' then
    
      update come_empl
         set empl_desc                = bcab.empl_desc,
             empl_esta                = bcab.empl_esta,
             empl_base                = bcab.empl_base,
             empl_cost_hora           = bcab.empl_cost_hora,
             empl_tido_codi           = bcab.empl_tido_codi,
             empl_cara                = bcab.empl_cara,
             empl_clpr_codi           = bcab.empl_clpr_codi,
             empl_emse_codi           = bcab.empl_emse_codi,
             empl_cedu_nume           = bcab.empl_cedu_nume,
             empl_dire                = bcab.empl_dire,
             empl_fech_ingr           = bcab.empl_fech_ingr,
             empl_fech_baja           = bcab.empl_fech_baja,
             empl_sala_actu           = bcab.empl_sala_actu,
             empl_mail                = bcab.empl_mail,
             empl_tele                = bcab.empl_tele,
             empl_obse                = bcab.empl_obse,
             empl_fech_naci           = bcab.empl_fech_naci,
             empl_luga_naci           = bcab.empl_luga_naci,
             empl_grup_sang           = bcab.empl_grup_sang,
             empl_cost_hora_mmee      = bcab.empl_cost_hora_mmee,
             empl_suel_mone_codi      = bcab.empl_suel_mone_codi,
             empl_tili_codi           = bcab.empl_tili_codi,
             empl_tipe_codi           = bcab.empl_tipe_codi,
             empl_porc_hora_extr_manu = bcab.empl_porc_hora_extr_manu,
             empl_sucu_codi           = bcab.empl_sucu_codi,
             empl_tipo_empl           = bcab.empl_tipo_empl,
             empl_cage_codi           = bcab.empl_cage_codi,
             empl_gest_codi           = bcab.empl_gest_codi,
             empl_nume_cuen           = bcab.empl_nume_cuen,
             empl_banc_codi_cuen      = bcab.empl_banc_codi_cuen,
             empl_indi_excl_liqu      = bcab.empl_indi_excl_liqu,
             empl_secu_presu          = bcab.empl_secu_presu,
             empl_inic_presu          = bcab.empl_inic_presu,
             empl_dom_otr_prof        = bcab.empl_dom_otr_prof,
             empl_val_otr_prof        = bcab.empl_val_otr_prof,
             empl_dom_niv_est         = bcab.empl_dom_niv_est,
             empl_val_niv_est         = bcab.empl_val_niv_est,
             empl_dom_nac             = bcab.empl_dom_nac,
             empl_val_nac             = bcab.empl_val_nac,
             empl_foto                = bcab.empl_foto,
             empl_dom_tip_empl        = bcab.empl_dom_tip_empl,
             empl_dom_sexo            = bcab.empl_dom_sexo,
             empl_val_sexo            = bcab.empl_val_sexo,
             empl_lib_legal           = bcab.empl_lib_legal,
             empl_hs_extr             = bcab.empl_hs_extr,
             empl_aporta_ips          = bcab.empl_aporta_ips,
             empl_calc_ips            = bcab.empl_calc_ips,
             empl_iva                 = bcab.empl_iva,
             empl_aso                 = bcab.empl_aso,
             empl_deb_cre             = bcab.empl_deb_cre,
             empl_marc_hor            = bcab.empl_marc_hor,
             empl_regi                = bcab.empl_regi,
             -- empl_user_regi           = fp_user,
             -- empl_fech_regi           = sysdate,
             empl_user_modi       = fp_user,
             empl_fech_modi       = sysdate,
             empl_codi_alte       = bcab.empl_codi_alte,
             empl_empr_codi       = bcab.empl_empr_codi,
             empl_val_est_ips     = bcab.empl_val_est_ips,
             empl_val_cargo       = bcab.empl_val_cargo,
             empl_dom_cargo       = bcab.empl_dom_cargo,
             empl_dom_est_ips     = bcab.empl_dom_est_ips,
             empl_nro_ips         = bcab.empl_nro_ips,
             empl_clave_marc      = bcab.empl_clave_marc,
             empl_fec_ent_ips     = bcab.empl_fec_ent_ips,
             empl_fec_ent_mjt     = bcab.empl_fec_ent_mjt,
             empl_fec_sal_ips     = bcab.empl_fec_sal_ips,
             empl_fec_sal_mjt     = bcab.empl_fec_sal_mjt,
             empl_sup_inm         = bcab.empl_sup_inm,
             empl_cod_hora        = bcab.empl_cod_hora,
             empl_dom_cat_mjt     = bcab.empl_dom_cat_mjt,
             empl_val_cat_mjt     = bcab.empl_val_cat_mjt,
             empl_cod_reloj       = bcab.empl_cod_reloj,
             empl_hora_fech_vige  = bcab.empl_hora_fech_vige,
             empl_hora_rota       = bcab.empl_hora_rota,
             empl_porc_comi       = bcab.empl_porc_comi,
             empl_porc_comi_gcia  = bcab.empl_porc_comi_gcia,
             empl_kilo_reco_chof  = bcab.empl_kilo_reco_chof,
             empl_hora_reco_chof  = bcab.empl_hora_reco_chof,
             empl_fech_venc_habi  = bcab.empl_fech_venc_habi,
             empl_nume_habi       = bcab.empl_nume_habi,
             empl_obse_chof       = bcab.empl_obse_chof,
             empl_maxi_porc_deto  = bcab.empl_maxi_porc_deto,
             empl_sala_actu_compl = bcab.empl_sala_actu_compl,
             -- empl_imag                = bcab.empl_imag,
             empl_maxi_plaz_cobr      = bcab.empl_maxi_plaz_cobr,
             empl_ceco_codi           = bcab.empl_ceco_codi,
             empl_cont_supe           = bcab.empl_cont_supe,
             empl_cant_vale_sald      = bcab.empl_cant_vale_sald,
             empl_turn_codi           = bcab.empl_turn_codi,
             empl_plsu_codi           = bcab.empl_plsu_codi,
             empl_list_codi           = bcab.empl_list_codi,
             empl_cant_plan_pend      = bcab.empl_cant_plan_pend,
             empl_banc_codi_cuen_comp = bcab.empl_banc_codi_cuen_comp,
             empl_nume_cuen_comp      = bcab.empl_nume_cuen_comp,
             empl_indi_cobr_cheq      = bcab.empl_indi_cobr_cheq,
             empl_codi_empl_refe      = bcab.empl_codi_empl_refe,
             empl_firma_elect         = nvl(bcab.empl_firma_elect,
                                            empl_firma_elect),
             empl_organigrama         = bcab.empl_organigrama,
             -- empl_id_files_archivo    = bcab.empl_id_files_archivo,
             empl_nomb_equi          = bcab.empl_nomb_equi,
             empl_nomb_abre          = bcab.empl_nomb_abre,
             empl_nro_corporativo    = bcab.empl_nro_corporativo,
             empl_orde_dist_recl_cli = bcab.empl_orde_dist_recl_cli,
             empl_codi_wolkvox       = bcab.empl_codi_wolkvox,
             empl_codi_bitrix        = bcab.empl_codi_bitrix
       where empl_codi = bcab.empl_codi;
    
    elsif p_opcion = 'DELETE' then
    
      update come_empl
         set empl_base = parameter.p_codi_base
       where empl_codi = bcab.empl_codi;
    
      delete from come_empl_dir c where c.emdir_empl_cod = bcab.empl_codi;
    
      delete from come_empl_tel c where c.emtel_empl_cod = bcab.empl_codi;
    
      delete from come_empl_ident c where c.emid_empl_cod = bcab.empl_codi;
    
      delete from come_empl_fami_deta c
       where c.deta_empl_codi = bcab.empl_codi;
    
      delete from come_empl_imag c where c.emim_empl_codi = bcab.empl_codi;
    
      delete come_empl where empl_codi = bcab.empl_codi;
    
    end if;
  
    --pl_me(p_opcion);
  
    if p_opcion <> 'DELETE' then
      for x in iden loop
      
        i010137.pp_iden_actualizar(p_emid_empl_cod => bcab.empl_codi, --x.emid_empl_cod,
                                   p_emid_item     => x.emid_item,
                                   p_emid_tipo     => x.tipo,
                                   p_emid_nro      => x.numero,
                                   p_emid_fec_vto  => x.vencimiento,
                                   p_opcion        => x.oper);
      end loop;
    
      for x in tele loop
        --  raise_application_error(-20001, 'adf');
        i010137.pp_tele_actualizar(p_emtel_empl_cod    => bcab.empl_codi,
                                   p_emtel_item        => x.emtel_item,
                                   p_emtel_area        => x.emtel_area,
                                   p_emtel_nro_tel     => x.emtel_nro_tel,
                                   p_emdir_dom_tip_tel => x.emdir_dom_tip_tel,
                                   p_emtel_val_tip     => x.emtel_val_tip,
                                   p_emdir_dom_ubic    => x.emdir_dom_ubic,
                                   p_emtel_val_ubic    => x.emtel_val_ubic,
                                   p_emtel_int         => x.emtel_int,
                                   p_emtel_nota        => x.emtel_nota,
                                   p_emtel_princ       => x.emtel_princ,
                                   p_opcion            => x.opcion);
      end loop;
    
      for x in dire loop
      
        I010137.PP_DIRE_ACTUALIZAR(P_EMDIR_EMPL_COD    => bcab.empl_codi,
                                   P_EMDIR_COD         => x.EMDIR_COD,
                                   P_EMDIR_DESC        => x.EMDIR_DESC,
                                   P_EMDIR_NRO_CASA    => x.EMDIR_NRO_CASA,
                                   P_EMDIR_PAIS        => x.EMDIR_PAIS,
                                   P_EMDIR_DEPA        => x.EMDIR_DEPA,
                                   P_EMDIR_CIUD        => x.EMDIR_CIUD,
                                   P_EMDIR_BARR        => x.EMDIR_BARR,
                                   P_EMDIR_CORREO      => x.EMDIR_CORREO,
                                   P_EMDIR_COD_POSTAL  => x.EMDIR_COD_POSTAL,
                                   P_EMDIR_DOM_TIP_VIV => x.EMDIR_DOM_TIP_VIV,
                                   P_EMDIR_VAL_TIP_VIV => x.EMDIR_VAL_TIP_VIV,
                                   P_EMDIR_DIR_PRINC   => x.EMDIR_DIR_PRINC,
                                   P_OPCION            => x.OPCION);
      
      end loop;
    
      for x in fami loop
        I010137.pp_fami_actualizar(P_DETA_EMPL_CODI   => bcab.empl_codi,
                                   P_DETA_NUME_ITEM   => x.DETA_NUME_ITEM,
                                   P_DETA_FAMI_CODI   => x.DETA_FAMI_CODI,
                                   P_DETA_NOMB_FAMI   => x.DETA_NOMB_FAMI,
                                   P_DETA_FECH_NACI   => x.DETA_FECH_NACI,
                                   P_DETA_INDI_BONI   => x.DETA_INDI_BONI,
                                   P_DETA_SEXO        => x.DETA_SEXO,
                                   P_DETA_BASE        => x.DETA_BASE,
                                   P_DETA_DOM_NIV_EST => x.DETA_DOM_NIV_EST,
                                   P_DETA_NIV_EST     => x.DETA_NIV_EST,
                                   P_DETA_OBS         => x.DETA_OBS,
                                   P_OPCION           => x.OPCION);
      
      end loop;
    end if;
  exception
    when others then
      pl_me('aca:' || sqlerrm);
  end pp_actualizar;

  procedure pp_muestra_come_empr_dept(p_emse_codi in number,
                                      p_desc_dpto out varchar2) is
    v_emde_codi number;
  begin
    select emse_emde_codi
      into v_emde_codi
      from come_empr_secc
     where emse_codi = p_emse_codi;
    if v_emde_codi is not null then
      begin
        select emde_desc
          into p_desc_dpto
          from come_empr_dept
         where emde_codi = v_emde_codi;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'Departamento de la empresa Inexistente');
        
      end;
    end if;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Seccion de la empresa Inexistente');
    
  end pp_muestra_come_empr_dept;

  procedure pp_veri_cuen_banc(p_cuen_codi in number) is
  
  begin
  
    if p_cuen_codi <> parameter.p_codi_banc_depo_suel_1 then
      if p_cuen_codi <> parameter.p_codi_banc_depo_suel_2 then
        raise_application_error(-20001,
                                'La Entidad Bancaria es distinta a la configurada en los parametros p_codi_banc_depo_suel_1 y p_codi_banc_depo_suel_2, favor verifique!');
      end if;
    end if;
  
  end pp_veri_cuen_banc;

  procedure pp_validar_reloj(p_empl_cod_reloj in number) is
  
    v_existe number;
  begin
    select count(*)
      into v_existe
      from come_empl e
     where empl_cod_reloj = p_empl_cod_reloj
       and e.empl_codi <> v('P106_EMPL_CODI');
    if nvl(v_existe, 0) > 0 then
      raise_application_error(-20001, 'C?digo de Reloj ya existe!');
    end if;
  end pp_validar_reloj;

  procedure pp_editar_imagen(p_emim_empl_codi in varchar2,
                             p_imagen         in varchar2) is
  
    v_archivo       blob;
    v_mime_type     varchar2(2000);
    v_filename      varchar2(2000);
    v_cantidad      number;
    v_extr_vehi_cod number;
  begin
  
    if p_imagen is null then
    
      raise_application_error(-20001, 'La imagen no puede quedar vacia');
    end if;
  
    begin
      select blob_content, mime_type, filename
        into v_archivo, v_mime_type, v_filename
        from APEX_APPLICATION_FILES A
       where A.NAME = p_imagen
         and ROWNUM = 1;
    exception
      when others then
        null;
    end;
  
    insert into come_empl_imag
      (emim_empl_codi, emim_imag)
    values
      (p_emim_empl_codi, v_archivo);
  
  end pp_editar_imagen;
  procedure pp_antiguedad(p_empl_fech_ingr in date,
                          p_s_mes          out varchar2,
                          p_s_dias         out varchar2,
                          p_s_anhos        out varchar2) is
    V_ANHO    number;
    V_FEC_MES date;
    V_MES     number;
    V_FEC_DIA date;
    V_DIA     number;
  begin
    if p_empl_fech_ingr is not null then
      v_anho    := trunc(months_between(trunc(sysdate), p_empl_fech_ingr) / 12);
      v_fec_mes := add_months(p_empl_fech_ingr, v_anho * 12);
      v_mes     := trunc(months_between(trunc(sysdate), v_fec_mes));
      v_fec_dia := add_months(v_fec_mes, v_mes);
      v_dia     := trunc(sysdate) - v_fec_dia;
      p_s_mes   := v_mes;
      p_s_dias  := v_dia;
      p_s_anhos := v_anho;
    
    end if;
  end pp_antiguedad;

  procedure pp_iden_coll(p_emid_empl_cod in varchar2,
                         p_emid_item     in varchar2,
                         p_emid_tipo     in varchar2,
                         p_emid_nro      in varchar2,
                         p_emid_fec_vto  in varchar2,
                         p_opcion        in varchar2,
                         p_seq_id        in number) is
  
    v_opcion varchar2(60);
  begin
  
    if p_seq_id is not null then
    
      apex_collection.delete_member(p_collection_name => 'IDENTIFICACIONES',
                                    p_seq             => p_seq_id);
    end if;
  
    if p_seq_id is not null and p_emid_empl_cod is null and
       p_opcion = 'SAVE' then
      v_opcion := 'CREATE';
    else
      v_opcion := p_opcion;
    end if;
  
    apex_collection.add_member(p_collection_name => 'IDENTIFICACIONES',
                               p_c001            => p_emid_empl_cod,
                               p_c002            => p_emid_item,
                               p_c003            => p_emid_tipo,
                               p_c004            => p_emid_nro,
                               p_c005            => p_emid_fec_vto,
                               p_c006            => v_opcion);
  
  end pp_iden_coll;

  procedure pp_tele_coll(p_emtel_empl_cod    in varchar2,
                         p_emtel_item        in varchar2,
                         p_emtel_area        in varchar2,
                         p_emtel_nro_tel     in varchar2,
                         p_emdir_dom_tip_tel in varchar2,
                         p_emtel_val_tip     in varchar2,
                         p_emdir_dom_ubic    in varchar2,
                         p_emtel_val_ubic    in varchar2,
                         p_emtel_int         in varchar2,
                         p_emtel_nota        in varchar2,
                         p_emtel_princ       in varchar2,
                         p_opcion            in varchar2,
                         p_seq_id            in number) is
  
    v_opcion varchar2(60);
  begin
  
    if p_seq_id is not null then
    
      apex_collection.delete_member(p_collection_name => 'TELEFONO',
                                    p_seq             => p_seq_id);
    end if;
  
    if p_seq_id is not null and p_emtel_empl_cod is null and
       p_opcion = 'SAVE' then
      v_opcion := 'CREATE';
    else
      v_opcion := p_opcion;
    end if;
    --raise_application_error (-20001,p_seq_id||'--'||p_emtel_empl_cod ||'--'||p_opcion);
  
    apex_collection.add_member(p_collection_name => 'TELEFONO',
                               p_c001            => p_emtel_empl_cod,
                               p_c002            => p_emtel_item,
                               p_c003            => p_emtel_area,
                               p_c004            => p_emtel_nro_tel,
                               p_c005            => p_emdir_dom_tip_tel,
                               p_c006            => p_emtel_val_tip,
                               p_c007            => p_emdir_dom_ubic,
                               p_c008            => p_emtel_val_ubic,
                               p_c009            => p_emtel_int,
                               p_c010            => p_emtel_nota,
                               p_c011            => p_emtel_princ,
                               p_c012            => v_opcion);
  
  end pp_tele_coll;

  procedure pp_dire_coll(p_emdir_empl_cod    in varchar2,
                         p_emdir_cod         in varchar2,
                         p_emdir_desc        in varchar2,
                         p_emdir_nro_casa    in varchar2,
                         p_emdir_pais        in varchar2,
                         p_emdir_depa        in varchar2,
                         p_emdir_ciud        in varchar2,
                         p_emdir_barr        in varchar2,
                         p_emdir_correo      in varchar2,
                         p_emdir_cod_postal  in varchar2,
                         p_emdir_dom_tip_viv in varchar2,
                         p_emdir_val_tip_viv in varchar2,
                         p_emdir_dir_princ   in varchar2,
                         p_opcion            in varchar2,
                         p_seq_id            in number) is
  
    v_opcion varchar2(60);
  begin
  
    if p_seq_id is not null then
    
      apex_collection.delete_member(p_collection_name => 'DIRECCION',
                                    p_seq             => p_seq_id);
    end if;
  
    if p_seq_id is not null and p_emdir_empl_cod is null and
       p_opcion = 'SAVE' then
      v_opcion := 'CREATE';
    else
      v_opcion := p_opcion;
    end if;
    --raise_application_error (-20001,p_seq_id||'--'||p_emtel_empl_cod ||'--'||p_opcion);
  
    apex_collection.add_member(p_collection_name => 'DIRECCION',
                               p_c001            => p_emdir_empl_cod,
                               p_c002            => p_emdir_cod,
                               p_c003            => p_emdir_desc,
                               p_c004            => p_emdir_nro_casa,
                               p_c005            => p_emdir_pais,
                               p_c006            => p_emdir_depa,
                               p_c007            => p_emdir_ciud,
                               p_c008            => p_emdir_barr,
                               p_c009            => p_emdir_correo,
                               p_c010            => p_emdir_cod_postal,
                               p_c011            => p_emdir_dom_tip_viv,
                               p_c012            => p_emdir_val_tip_viv,
                               p_c013            => p_emdir_dir_princ,
                               p_c014            => v_opcion);
  
  end pp_dire_coll;

  procedure pp_fami_coll(p_deta_empl_codi   in varchar2,
                         p_deta_nume_item   in varchar2,
                         p_deta_fami_codi   in varchar2,
                         p_deta_nomb_fami   in varchar2,
                         p_deta_fech_naci   in date,
                         p_deta_indi_boni   in varchar2,
                         p_deta_sexo        in varchar2,
                         p_deta_base        in varchar2,
                         p_deta_dom_niv_est in varchar2,
                         p_deta_niv_est     in varchar2,
                         p_deta_obs         in varchar2,
                         p_opcion           in varchar2,
                         p_seq_id           in number) is
  
    v_opcion varchar2(60);
    edad     varchar2(60);
  begin
  
    if p_seq_id is not null then
      apex_collection.delete_member(p_collection_name => 'FAMILIA',
                                    p_seq             => p_seq_id);
    end if;
  
    if p_seq_id is not null and p_deta_empl_codi is null and
       p_opcion = 'SAVE' then
      v_opcion := 'CREATE';
    else
      v_opcion := p_opcion;
    end if;
    --raise_application_error (-20001,p_seq_id||'--'||p_emtel_empl_cod ||'--'||p_opcion);
    if p_deta_fech_naci is not null then
      edad := trunc((sysdate - p_deta_fech_naci) / 365);
    end if;
    apex_collection.add_member(p_collection_name => 'FAMILIA',
                               p_c001            => p_deta_empl_codi,
                               p_c002            => p_deta_nume_item,
                               p_c003            => p_deta_fami_codi,
                               p_c004            => p_deta_nomb_fami,
                               p_c005            => p_deta_fech_naci,
                               p_c006            => p_deta_indi_boni,
                               p_c007            => p_deta_sexo,
                               p_c008            => p_deta_base,
                               p_c009            => p_deta_dom_niv_est,
                               p_c010            => p_deta_niv_est,
                               p_c011            => p_deta_obs,
                               p_c012            => edad,
                               p_c013            => v_opcion);
  
  end pp_fami_coll;

  procedure pp_cargar_grillas(p_empleado in number) is
    cursor ident is
      select t.emid_empl_cod,
             t.emid_item,
             t.emid_tipo,
             t.emid_nro,
             t.emid_fec_vto
        from come_empl_ident t
       where emid_empl_cod = p_empleado;
  
    cursor dire is
      select emdir_empl_cod,
             emdir_cod,
             emdir_desc,
             emdir_nro_casa,
             emdir_pais,
             emdir_depa,
             emdir_ciud,
             emdir_barr,
             emdir_correo,
             emdir_cod_postal,
             emdir_dom_tip_viv,
             emdir_val_tip_viv,
             emdir_dir_princ
        from come_empl_dir
       where emdir_empl_cod = p_empleado;
  
    cursor tele is
      select emtel_empl_cod,
             emtel_item,
             emtel_area,
             emtel_nro_tel,
             emdir_dom_tip_tel,
             emtel_val_tip,
             emdir_dom_ubic,
             emtel_val_ubic,
             emtel_int,
             emtel_nota,
             emtel_princ
        from come_empl_tel
       where emtel_empl_cod = p_empleado;
  
    cursor fami is
      select deta_empl_codi,
             deta_nume_item,
             deta_fami_codi,
             deta_nomb_fami,
             deta_fech_naci,
             deta_indi_boni,
             deta_sexo,
             deta_base,
             deta_dom_niv_est,
             deta_niv_est,
             deta_obs,
             trunc((sysdate - deta_fech_naci) / 365) Edad
        from come_empl_fami_deta
       where deta_empl_codi = p_empleado;
  
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'IDENTIFICACIONES');
    apex_collection.create_or_truncate_collection(p_collection_name => 'TELEFONO');
    apex_collection.create_or_truncate_collection(p_collection_name => 'FAMILIA');
    apex_collection.create_or_truncate_collection(p_collection_name => 'DIRECCION');
    for x in ident loop
    
      apex_collection.add_member(p_collection_name => 'IDENTIFICACIONES',
                                 p_c001            => x.emid_empl_cod,
                                 p_c002            => x.emid_item,
                                 p_c003            => x.emid_tipo,
                                 p_c004            => x.emid_nro,
                                 p_c005            => x.emid_fec_vto);
    
    end loop;
  
    for x in dire loop
    
      apex_collection.add_member(p_collection_name => 'DIRECCION',
                                 p_c001            => x.emdir_empl_cod,
                                 p_c002            => x.emdir_cod,
                                 p_c003            => x.emdir_desc,
                                 p_c004            => x.emdir_nro_casa,
                                 p_c005            => x.emdir_pais,
                                 p_c006            => x.emdir_depa,
                                 p_c007            => x.emdir_ciud,
                                 p_c008            => x.emdir_barr,
                                 p_c009            => x.emdir_correo,
                                 p_c010            => x.emdir_cod_postal,
                                 p_c011            => x.emdir_dom_tip_viv,
                                 p_c012            => x.emdir_val_tip_viv,
                                 p_c013            => x.emdir_dir_princ);
    
    end loop;
  
    for x in tele loop
    
      apex_collection.add_member(p_collection_name => 'TELEFONO',
                                 p_c001            => x.emtel_empl_cod,
                                 p_c002            => x.emtel_item,
                                 p_c003            => x.emtel_area,
                                 p_c004            => x.emtel_nro_tel,
                                 p_c005            => x.emdir_dom_tip_tel,
                                 p_c006            => x.emtel_val_tip,
                                 p_c007            => x.emdir_dom_ubic,
                                 p_c008            => x.emtel_val_ubic,
                                 p_c009            => x.emtel_int,
                                 p_c010            => x.emtel_nota,
                                 p_c011            => x.emtel_princ);
    
    end loop;
  
    for x in fami loop
    
      apex_collection.add_member(p_collection_name => 'FAMILIA',
                                 p_c001            => x.deta_empl_codi,
                                 p_c002            => x.deta_nume_item,
                                 p_c003            => x.deta_fami_codi,
                                 p_c004            => x.deta_nomb_fami,
                                 p_c005            => x.deta_fech_naci,
                                 p_c006            => x.deta_indi_boni,
                                 p_c007            => x.deta_sexo,
                                 p_c008            => x.deta_base,
                                 p_c009            => x.deta_dom_niv_est,
                                 p_c010            => x.deta_niv_est,
                                 p_c011            => x.deta_obs,
                                 p_c012            => x.edad);
    end loop;
  
  end pp_cargar_grillas;

/* select c001 emid_empl_cod,
        c002 emid_item,
        c003 emid_tipo Tipo,
        c004 emid_nro  Numero,
        c005 emid_fec_vto Vencimiento,
        seq id
 from apex_collections
        where collection_name ='IDENTIFICACIONES'*/

/*  select c001 emtel_empl_cod,
         c002 emtel_item,
         c003 emtel_area,
         c004 emtel_nro_tel,
         c005 emdir_dom_tip_tel,
         c006 emtel_val_tip,
         c007 emdir_dom_ubic,
         c008 emtel_val_ubic,
         c009 emtel_int,
         c010 emtel_nota,
         c011 emtel_princ,
         decode(emtel_princ,'S','Si', 'No') Principal
         seq_id
    from apex_collections
   where collection_name = 'TELEFONO'
     and nvl(c012,'a')  <> 'DELETE'*/

/*   SELECT
      c001  deta_empl_codi,
      c002  deta_nume_item,
      c003  deta_fami_codi,
      c004  deta_nomb_fami,
      c005  deta_fech_naci,
      c006  deta_indi_boni,
      c007  deta_sexo,
      c008  deta_base,
      c009  deta_dom_niv_est,
      c010  deta_niv_est,
      c011  deta_obs
      c012  edad,
      c013  opcion
      seq_id
   from apex_collections
   where collection_name = 'FAMILIA'
     and nvl(c012,'a')  <> 'DELETE'                   */
end I010137;
