
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010014" is

  type t_parameter is record(
    p_indi_apex     varchar2(10) := general_skn.fl_busca_parametro('p_indi_apex'),
    p_codi_base     number := pack_repl.fa_devu_codi_base,
    p_indi_app_movi varchar2(10) := general_skn.fl_busca_parametro('p_indi_app_movi'),
    p_indi_abrir    varchar2(10),
    p_user_codi     number

    );

  parameter t_parameter;
  type t_babmc is record(
    user_codi                      number,
    codigo                         number,
    user_codi_orig                 number,
    user_desc                      varchar2(60),
    user_login                     varchar2(20),
    user_indi_admi                 varchar2(1),
    user_base                      number,
    user_empl_codi                 number,
    user_mail                      varchar2(100),
    user_indi_ortr_limi_cost       varchar2(1),
    user_indi_gene_dife_inve       varchar2(1),
    user_indi_modi_limi_cost_inic  varchar2(1),
    user_clpr_codi                 number,
    user_indi_modi_buzo_cobr       varchar2(1),
    user_user_regi                 varchar2(20),
    user_fech_regi                 date,
    user_user_modi                 varchar2(20),
    user_fech_modi                 date,
    user_indi_modi_maxi_porc_clie  varchar2(1),
    user_nive_codi                 number,
    user_indi_proc_comi            varchar2(1),
    user_indi_modi_cuen_cont       varchar2(1),
    user_indi_real_deto_sin_exce   varchar2(1),
    user_tiem_mens                 number,
    user_indi_noti_cump_clie       varchar2(1),
    user_indi_modi_cier_caja       varchar2(1),
    user_indi_cier_caja_dife       varchar2(1),
    user_upass                     varchar2(60),
    user_spass                     varchar2(60),
    user_indi_modi_dato_clie       varchar2(1),
    user_depo_codi                 number,
    user_indi_cobr_vend            varchar2(1),
    user_indi_modi_soli_serv       varchar2(1),
    user_cuen_codi_gs              number,
    user_cuen_codi_us              number,
    user_indi_modi_cier_plan_chic  varchar2(1),
    user_indi_form_mens            varchar2(1),
    user_auto_limi_cred            varchar2(1),
    user_auto_situ_clie            varchar2(1),
    user_auto_cheq_rech            varchar2(1),
    user_auto_desc_prod            varchar2(1),
    user_auto_anal_cred            varchar2(1),
    user_auto_supe_vent            varchar2(1),
    user_auto_gere_gene            varchar2(1),
    user_indi_modi_camp_agent      varchar2(1),
    user_indi_modi_camp_clas_clien varchar2(1),
    user_indi_modi_camp_cobr       varchar2(1),
    user_indi_modi_camp_recl       varchar2(1),
    user_indi_modi_camp_tele       varchar2(1),
    user_indi_modi_camp_list_prec  varchar2(1),
    user_indi_modi_camp_form_pago  varchar2(1),
    user_indi_modi_dato_ot_fini    varchar2(1),
    user_codi_empl_admi            number,
    user_indi_crea_veri_sose       varchar2(1),
    user_indi_modi_dato_vehi       varchar2(1),
    user_indi_borr_pres_clie       varchar2(1),
    user_indi_app_movi_onli        varchar2(1),
    user_indi_auto_anex            varchar2(1),
    user_indi_modi_anex_auto       varchar2(1),
    user_indi_cier_caja_vale_pend  varchar2(1),
    user_secu_codi                 number,
    user_lipr_codi                 number,
    user_orte_codi                 number,
    user_clcl_codi                 number,
    user_indi_modi_inve_tele       varchar2(1),
    user_indi_most_mens            varchar2(1),
    user_indi_gps                  varchar2(1),
    user_indi_pane                 varchar2(1),
    user_esta_pane                 varchar2(1),
    user_fech_pane                 date,
    user_perf_codi                 number,
    -- user_imag                      BLOB,
    user_perf_desc_inte_codi      number,
    user_pass                     varchar2(4000),
    pass                          varchar2(4000),
    user_indi_modi_pres           varchar2(1),
    user_fech_maxi_habi           date,
    user_indi_ver_cost_gast_logi  varchar2(1),
    user_indi_borr_proc_pane_fact varchar2(1),
    user_agen_codi                number,
    user_grua_codi                number,
    user_indi_bloq                varchar2(1),
    user_indi_modi_fech_orpa      varchar2(1),
    user_indi_impr_reci_cons_inte varchar2(1),
    user_indi_modi_noti_clie      varchar2(1),
    user_indi_crea_noti_clie      varchar2(1),
    mimetype                      varchar2(255),
    filename                      varchar2(400),
    user_indi_modi_camp_desc      varchar2(1),
    user_indi_modi_camp_ruc       varchar2(1),
    user_indi_modi_camp_secc_exce varchar2(1),
    user_indi_modi_camp_situ      varchar2(1),
    user_indi_modi_camp_form_fact varchar2(1),
    user_indi_modi_camp_esta      varchar2(1),
    user_indi_gene_pre_anex_ot    varchar2(1),
    user_indi_modi_obse_fact_deta varchar2(1),
    user_indi_modi_vent_comp      varchar2(1),
    user_clre_codi                number,
    user_toke                     varchar2(2000),
    user_indi_ver_cost_gast_perd  varchar2(1),
    user_indi_fact_inmu_modi_inte varchar2(1),
    user_indi_fact_inmu_fech_dife varchar2(1),
    user_indi_fact_inmu_modi_nume varchar2(1),
    user_indi_anul_remi           varchar2(1),
    user_indi_borr_liqu_ot        varchar2(1),
    user_indi_impr_cons_docu      varchar2(1),
    user_indi_des_liqu_ot         varchar2(1),
    user_indi_borr_ot             varchar2(1),
    user_indi_most_even           varchar2(1),
    user_token_fcm                varchar2(2000),
    user_indi_limi_sucu_repo_vent varchar2(1),
    user_indi_cont_hora           varchar2(1),
    user_indi_rel_evento          varchar2(1),
    user_tele                     varchar2(50),
    user_indi_comi_vend            varchar2(1)
    );
  babmc t_babmc;

  cursor cur_empr is
    select seq_id,
           c001   empr_codi,
           c002   usem_user_codi,
           c003   usem_base,
           c004   s_pred_orig, --usem_indi_pred,
           c005   empresa,
           c007   s_habilitado,
           c008   s_pred,
           c009   s_estado_orig
      from apex_collections a
     where a.collection_name = 'EMPRESA';

  cursor cur_sucu is
    select seq_id,
           c001   sucu_codi,
           c002   ussu_user_codi,
           c003   ussu_base,
           c004   s_pred_orig, --ussu_indi_pred,
           c005   sucursal,
           c006   empresa,
           c007   s_habilitado,
           c008   s_pred,
           c009   s_estado_orig
      from apex_collections a
     where a.collection_name = 'SUCURSAL';

  cursor cur_caja is
    select seq_id,
           c001   cuen_codi,
           c002   cuen_desc,
           c003   s_habilitado,
           c004   s_estado_orig
      from apex_collections a
     where a.collection_name = 'CAJAS';

  procedure pp_iniciar(p_user_codi in number, p_codigo out number) is
  begin

    if p_user_codi is null then
      select nvl(max(user_codi), 0) + 1 into p_codigo from segu_user;
    else
      p_codigo := p_user_codi;
    end if;
    i010014.pp_carcar_collections(p_user_codi);
    babmc.user_codi_orig := p_user_codi;

  end pp_iniciar;
  procedure pp_carcar_collections(p_user_codi in number) is

    cursor empresa is(
      select empr_codi,
             a.usem_user_codi,
             a.usem_base,
             a.usem_indi_pred,
             b.empr_desc empresa,
             case
               when a.usem_empr_codi is not null then
                'S'
               else
                'N'
             end hab,
             case
               when nvl(a.usem_indi_pred, 'N') = 'S' then
                'S'
               else
                'N'
             end pred

        from segu_user_empr a, come_empr b
       where a.usem_empr_codi(+) = b.empr_codi
         and usem_user_codi(+) = p_user_codi);

    cursor sucursal is(
      select d.sucu_codi,
             c.ussu_user_codi,
             c.ussu_base,
             c.ussu_indi_pred,
             d.sucu_desc sucursal,
             b.empr_desc empresa,
             case
               when c.ussu_sucu_codi is not null then
                'S'
               else
                'N'
             end hab,
             case
               when nvl(ussu_indi_pred, 'N') = 'S' then
                'S'
               else
                'N'
             end pred
        from come_empr b, segu_user_sucu c, come_sucu d
       where b.empr_codi = d.sucu_empr_codi
         and c.ussu_sucu_codi(+) = d.sucu_codi
         and c.ussu_user_codi(+) = p_user_codi);

    cursor c_segu_cuen is
      select cuen_desc, cuen_codi from come_cuen_banc order by 1;

    v_count         number := 0;
    v_cuen_codi     varchar2(100);
    v_cuen_desc     varchar2(1000);
    v_s_habilitado  varchar2(100);
    v_s_estado_orig varchar2(100);
  begin

    apex_collection.create_or_truncate_collection(p_collection_name => 'EMPRESA');
    apex_collection.create_or_truncate_collection(p_collection_name => 'SUCURSAL');
    apex_collection.create_or_truncate_collection(p_collection_name => 'CAJAS');

    for e in empresa loop
      apex_collection.add_member(p_collection_name => 'EMPRESA',
                                 p_c001            => e.empr_codi,
                                 p_c002            => e.usem_user_codi,
                                 p_c003            => e.usem_base,
                                 p_c004            => e.usem_indi_pred,
                                 p_c005            => e.empresa,
                                 p_c007            => e.hab,
                                 p_c008            => e.pred,
                                 p_c009            => e.hab);
    end loop;

    for s in sucursal loop
      apex_collection.add_member(p_collection_name => 'SUCURSAL',
                                 p_c001            => s.sucu_codi,
                                 p_c002            => s.ussu_user_codi,
                                 p_c003            => s.ussu_base,
                                 p_c004            => s.ussu_indi_pred,
                                 p_c005            => s.sucursal,
                                 p_c006            => s.empresa,
                                 p_c007            => s.hab,
                                 p_c008            => s.pred,
                                 p_c009            => s.hab);

    end loop;

    for x in c_segu_cuen loop

      v_cuen_codi := x.cuen_codi;
      v_cuen_desc := x.cuen_desc;

      select count(*)
        into v_count
        from segu_user_cuen
       where uscu_user_codi = p_user_codi
         and uscu_cuen_codi = x.cuen_codi;

      if v_count <> 0 then
        v_s_habilitado  := upper('s');
        v_s_estado_orig := upper('s');
      else
        v_s_habilitado  := upper('n');
        v_s_estado_orig := upper('n');
      end if;

      apex_collection.add_member(p_collection_name => 'CAJAS',
                                 p_c001            => v_cuen_codi,
                                 p_c002            => v_cuen_desc,
                                 p_c003            => v_s_habilitado,
                                 p_c004            => v_s_estado_orig);

    end loop;

  end pp_carcar_collections;

  procedure pp_valida_login(p_user_login in varchar2,
                            p_user_codi  in number) is

    v_ind_existe char(1);
    tabla        char(27) := 'ABCDEFGHIJKLMN?OPQRSTUVWXYZ';
    v_letra      char(1);
    v_ind_entro  char(1) := 'N';
    v_count      number;
  begin
    -- v_ind_existe :=   fa_verif_exist_usu(p_user_login);

    if v_ind_existe = 'S' then
      raise_application_error(-20001,
                              'El usuario ya est? registrado en la Base de Datos');
    end if;

    for x in 1 .. 27 loop
      v_letra := substr(tabla, x, 1);
      if substr(p_user_login, 1, 1) = v_letra then
        v_ind_entro := 'S';
      end if;
    end loop;

    if v_ind_entro = 'N' then
      raise_application_error(-20001,
                              'El Login Debe empezar con una Letra');
    end if;

    begin
      select count(*)
        into v_count
        from segu_user
       where user_codi = p_user_codi;

      if v_count > 0 then
        raise_application_error(-20001,
                                'El codigo de segu_user ya fue registrado por otro segu_user, Presione cancelar y vuelca a cargar los datos');
      end if;
    end;

  end pp_valida_login;

  procedure pp_valida_repe_empl(p_empl_codi in number,
                                p_user_codi in number) is

    v_count   number;
    v_mensaje varchar2(200);

    cursor c_user is
      select user_codi, user_desc
        from segu_user
       where user_empl_codi = p_empl_codi;

  begin

    select count(*)
      into v_count
      from segu_user
     where user_empl_codi = p_empl_codi
       and user_codi <> p_user_codi;
    -- raise_application_error(-20001,p_user_codi||'/ empl:'||p_empl_codi);
    if v_count > 0 then

      for x in c_user loop
        v_mensaje := v_mensaje || x.user_desc || ' con codigo ' ||
                     x.user_codi || '  ';
      end loop;

      raise_application_error(-20001,
                              'El Empleado ya esta asignado al/los usuario/s:  ' ||
                              v_mensaje);
    end if;

  end pp_valida_repe_empl;

  procedure pp_actualiza_segu_user_cuen is
  begin
    for babmc_cuen in cur_caja loop
      if babmc_cuen.s_habilitado <> babmc_cuen.s_estado_orig and
         babmc_cuen.cuen_codi is not null then
        if babmc_cuen.s_habilitado = upper('s') then
          insert into segu_user_cuen
            (uscu_user_codi, uscu_cuen_codi, uscu_base)
          values
            (babmc.user_codi, babmc_cuen.cuen_codi, parameter.p_codi_base);
        else
          update segu_user_cuen
             set uscu_base = parameter.p_codi_base
           where uscu_user_codi = babmc.user_codi
             and uscu_cuen_codi = babmc_cuen.cuen_codi;

          delete segu_user_cuen
           where uscu_user_codi = babmc.user_codi
             and uscu_cuen_codi = babmc_cuen.cuen_codi;
        end if;
      end if;
    end loop;
  end pp_actualiza_segu_user_cuen;

  procedure pp_actualiza_segu_user_empr is
  begin

    for babmc_mr_empr in cur_empr loop

      if babmc_mr_empr.s_habilitado <> babmc_mr_empr.s_estado_orig and
         babmc_mr_empr.empr_codi is not null then
        if babmc_mr_empr.s_habilitado = upper('s') then
          insert into segu_user_empr
            (usem_empr_codi, usem_user_codi, usem_base, usem_indi_pred)
          values
            (babmc_mr_empr.empr_codi,
             babmc.user_codi,
             parameter.p_codi_base,
             babmc_mr_empr.s_pred);
        else
          update segu_user_empr
             set usem_base = parameter.p_codi_base
           where usem_user_codi = babmc.user_codi
             and usem_empr_codi = babmc_mr_empr.empr_codi;

          delete segu_user_empr
           where usem_user_codi = babmc.user_codi
             and usem_empr_codi = babmc_mr_empr.empr_codi;
        end if;
      elsif babmc_mr_empr.s_pred <> nvl(babmc_mr_empr.s_pred_orig, 'X') then
        update segu_user_empr
           set usem_indi_pred = babmc_mr_empr.s_pred
         where usem_user_codi = babmc.user_codi
           and usem_empr_codi = babmc_mr_empr.empr_codi;
      end if;

    end loop;
  end pp_actualiza_segu_user_empr;

  procedure pp_actualiza_segu_user_sucu is
  begin

    for babmc_mr_sucu in cur_sucu loop
      if babmc_mr_sucu.s_habilitado <> babmc_mr_sucu.s_estado_orig and
         babmc_mr_sucu.sucu_codi is not null then
        if babmc_mr_sucu.s_habilitado = upper('s') then

          insert into segu_user_sucu
            (ussu_sucu_codi, ussu_user_codi, ussu_base, ussu_indi_pred)
          values
            (babmc_mr_sucu.sucu_codi,
             babmc.user_codi,
             parameter.p_codi_base,
             babmc_mr_sucu.s_pred);
        else

          update segu_user_sucu
             set ussu_indi_pred = parameter.p_codi_base
           where ussu_user_codi = babmc.user_codi
             and ussu_sucu_codi = babmc_mr_sucu.sucu_codi;

          delete segu_user_sucu
           where ussu_user_codi = babmc.user_codi
             and ussu_sucu_codi = babmc_mr_sucu.sucu_codi;
        end if;
      else
        if babmc_mr_sucu.s_pred <> nvl(babmc_mr_sucu.s_pred_orig, 'X') then
          update segu_user_sucu
             set ussu_indi_pred = babmc_mr_sucu.s_pred
           where ussu_user_codi = babmc.user_codi
             and ussu_sucu_codi = babmc_mr_sucu.sucu_codi;
        end if;
      end if;

    end loop;
  end pp_actualiza_segu_user_sucu;


  procedure pp_genera_sentencia_delete is
    v_sentencia1 varchar2(200);
    v_count      number;

  begin

    ----validar que exsita a nivel de base de datos...
    begin
      select count(*)
        into v_count
        from dba_users
       where username = upper(rtrim(ltrim(babmc.user_login)));
    end;

    if babmc.user_login = 'SKN' then
      PL_ME('No se puede eliminar el usuario SKN');
    end if;

    if v_count > 0 then

      v_sentencia1 := 'DROP USER ' || babmc.user_login || ' CASCADE';
      pa_ejecuta_ddl(v_sentencia1);
    end if;

  end pp_genera_sentencia_delete;

  procedure pp_set_variable is

  begin

    ---***********************
    babmc.codigo                         := v('P101_CODIGO');
    babmc.filename                       := v('P101_FILENAME');
    babmc.mimetype                       := v('P101_MIMETYPE');
    babmc.pass                           := v('P101_PASS');
    babmc.user_agen_codi                 := v('P101_USER_AGEN_CODI');
    babmc.user_auto_anal_cred            := v('P101_USER_AUTO_ANAL_CRED');
    babmc.user_auto_cheq_rech            := v('P101_USER_AUTO_CHEQ_RECH');
    babmc.user_auto_desc_prod            := v('P101_USER_AUTO_DESC_PROD');
    babmc.user_auto_gere_gene            := v('P101_USER_AUTO_GERE_GENE');
    babmc.user_auto_limi_cred            := v('P101_USER_AUTO_LIMI_CRED');
    babmc.user_auto_situ_clie            := v('P101_USER_AUTO_SITU_CLIE');
    babmc.user_auto_supe_vent            := v('P101_USER_AUTO_SUPE_VENT');
    babmc.user_base                      := v('P101_USER_BASE');
    babmc.user_clcl_codi                 := v('P101_USER_CLCL_CODI');
    babmc.user_clpr_codi                 := v('P101_USER_CLPR_CODI');
    babmc.user_clre_codi                 := v('P101_USER_CLRE_CODI');
    babmc.user_codi                      := v('P101_USER_CODI');
    babmc.user_codi_empl_admi            := v('P101_USER_CODI_EMPL_ADMI');
    babmc.user_codi_orig                 := v('P101_USER_CODI');
    babmc.user_cuen_codi_gs              := v('P101_USER_CUEN_CODI_GS');
    babmc.user_cuen_codi_us              := v('P101_USER_CUEN_CODI_US');
    babmc.user_depo_codi                 := v('P101_USER_DEPO_CODI');
    babmc.user_desc                      := v('P101_USER_DESC');
    babmc.user_empl_codi                 := v('P101_USER_EMPL_CODI');
    babmc.user_esta_pane                 := v('P101_USER_ESTA_PANE');
    babmc.user_fech_maxi_habi            := v('P101_USER_FECH_MAXI_HABI');
    babmc.user_fech_pane                 := v('P101_USER_FECH_PANE');
    babmc.user_grua_codi                 := v('P101_USER_GRUA_CODI');
    babmc.user_indi_admi                 := v('P101_USER_INDI_ADMI');
    babmc.user_indi_anul_remi            := v('P101_USER_INDI_ANUL_REMI');
    babmc.user_indi_app_movi_onli        := v('P101_USER_INDI_APP_MOVI_ONLI');
    babmc.user_indi_auto_anex            := v('P101_USER_INDI_AUTO_ANEX');
    babmc.user_indi_bloq                 := v('P101_USER_INDI_BLOQ');
    babmc.user_indi_borr_liqu_ot         := v('P101_USER_INDI_BORR_LIQU_OT');
    babmc.user_indi_borr_ot              := v('P101_USER_INDI_BORR_OT');
    babmc.user_indi_borr_pres_clie       := v('P101_USER_INDI_BORR_PRES_CLIE');
    babmc.user_indi_borr_proc_pane_fact  := v('P101_USER_INDI_BORR_PROC_PANE_');
    babmc.user_indi_cier_caja_dife       := v('P101_USER_INDI_CIER_CAJA_DIFE');
    babmc.user_indi_cier_caja_vale_pend  := v('P101_USER_INDI_CIER_CAJA_VALE_');
    babmc.user_indi_cobr_vend            := v('P101_USER_INDI_COBR_VEND');
    babmc.user_indi_cont_hora            := v('P101_USER_INDI_CONT_HORA');
    babmc.user_indi_crea_noti_clie       := v('P101_USER_INDI_CREA_NOTI_CLIE');
    babmc.user_indi_crea_veri_sose       := v('P101_USER_INDI_CREA_VERI_SOSE');
    babmc.user_indi_des_liqu_ot          := v('P101_USER_INDI_DES_LIQU_OT');
    babmc.user_indi_fact_inmu_fech_dife  := v('P101_USER_INDI_FACT_INMU_FECH_');
    babmc.user_indi_fact_inmu_modi_inte  := v('P101_USER_INDI_FACT_INMU_MODI_');
    babmc.user_indi_fact_inmu_modi_nume  := v('P101_USER_INDI_FACT_INMU_MODI__1');
    babmc.user_indi_form_mens            := v('P101_USER_INDI_FORM_MENS');
    babmc.user_indi_gene_dife_inve       := v('P101_USER_INDI_GENE_DIFE_INVE');
    babmc.user_indi_gene_pre_anex_ot     := v('P101_USER_INDI_GENE_PRE_ANEX_OT');
    babmc.user_indi_gps                  := v('P101_USER_INDI_GPS');
    babmc.user_indi_impr_cons_docu       := v('P101_USER_INDI_IMPR_CONS_DOCU');
    babmc.user_indi_impr_reci_cons_inte  := v('P101_USER_INDI_IMPR_RECI_CONS_');
    babmc.user_indi_limi_sucu_repo_vent  := v('P101_USER_INDI_LIMI_SUCU_REPO_VENT');
    babmc.user_indi_modi_anex_auto       := v('P101_USER_INDI_MODI_ANEX_AUTO');
    babmc.user_indi_modi_buzo_cobr       := v('P101_USER_INDI_MODI_BUZO_COBR');
    babmc.user_indi_modi_camp_agent      := v('P101_USER_INDI_MODI_CAMP_AGENT');
    babmc.user_indi_modi_camp_clas_clien := v('P101_USER_INDI_MODI_CAMP_CLAS_');
    babmc.user_indi_modi_camp_cobr       := v('P101_USER_INDI_MODI_CAMP_COBR');
    babmc.user_indi_modi_camp_desc       := v('P101_USER_INDI_MODI_CAMP_DESC');
    babmc.user_indi_modi_camp_esta       := v('P101_USER_INDI_MODI_CAMP_ESTA');
    babmc.user_indi_modi_camp_form_fact  := v('P101_USER_INDI_MODI_CAMP_FORM__1');
    babmc.user_indi_modi_camp_form_pago  := v('P101_USER_INDI_MODI_CAMP_FORM_');
    babmc.user_indi_modi_camp_list_prec  := v('P101_USER_INDI_MODI_CAMP_LIST_');
    babmc.user_indi_modi_camp_recl       := v('P101_USER_INDI_MODI_CAMP_RECL');
    babmc.user_indi_modi_camp_ruc        := v('P101_USER_INDI_MODI_CAMP_RUC');
    babmc.user_indi_modi_camp_secc_exce  := v('P101_USER_INDI_MODI_CAMP_SECC_');
    babmc.user_indi_modi_camp_situ       := v('P101_USER_INDI_MODI_CAMP_SITU');
    babmc.user_indi_modi_camp_tele       := v('P101_USER_INDI_MODI_CAMP_TELE');
    babmc.user_indi_modi_cier_caja       := v('P101_USER_INDI_MODI_CIER_CAJA');
    babmc.user_indi_modi_cier_plan_chic  := v('P101_USER_INDI_MODI_CIER_PLAN_');
    babmc.user_indi_modi_cuen_cont       := v('P101_USER_INDI_MODI_CUEN_CONT');
    babmc.user_indi_modi_dato_clie       := v('P101_USER_INDI_MODI_DATO_CLIE');
    babmc.user_indi_modi_dato_ot_fini    := v('P101_USER_INDI_MODI_DATO_OT_FI');
    babmc.user_indi_modi_dato_vehi       := v('P101_USER_INDI_MODI_DATO_VEHI');
    babmc.user_indi_modi_fech_orpa       := v('P101_USER_INDI_MODI_FECH_ORPA');
    babmc.user_indi_modi_inve_tele       := v('P101_USER_INDI_MODI_INVE_TELE');
    babmc.user_indi_modi_limi_cost_inic  := v('P101_USER_INDI_MODI_LIMI_COST_');
    babmc.user_indi_modi_maxi_porc_clie  := v('P101_USER_INDI_MODI_MAXI_PORC_');
    babmc.user_indi_modi_noti_clie       := v('P101_USER_INDI_MODI_NOTI_CLIE');
    babmc.user_indi_modi_obse_fact_deta  := v('P101_USER_INDI_MODI_OBSE_FACT_');
    babmc.user_indi_modi_pres            := v('P101_USER_INDI_MODI_PRES');
    babmc.user_indi_modi_soli_serv       := v('P101_USER_INDI_MODI_SOLI_SERV');
    babmc.user_indi_modi_vent_comp       := v('P101_USER_INDI_MODI_VENT_COMP');
    babmc.user_indi_most_even            := v('P101_USER_INDI_MOST_EVEN');
    babmc.user_indi_most_mens            := v('P101_USER_INDI_MOST_MENS');
    babmc.user_indi_noti_cump_clie       := v('P101_USER_INDI_NOTI_CUMP_CLIE');
    babmc.user_indi_ortr_limi_cost       := v('P101_USER_INDI_ORTR_LIMI_COST');
    babmc.user_indi_ortr_limi_cost       := v('P101_USER_INDI_ORTR_LIMI_COST');
    babmc.user_indi_pane                 := v('P101_USER_INDI_PANE');
    babmc.user_indi_proc_comi            := v('P101_USER_INDI_PROC_COMI');
    babmc.user_indi_real_deto_sin_exce   := v('P101_USER_INDI_REAL_DETO_SIN_E');
    babmc.user_indi_rel_evento           := v('P101_USER_INDI_REL_EVENTO');
    babmc.user_indi_ver_cost_gast_logi   := v('P101_USER_INDI_VER_COST_GAST_L');
    babmc.user_indi_ver_cost_gast_perd   := v('P101_USER_INDI_VER_COST_GAST_P');
    babmc.user_lipr_codi                 := v('P101_USER_LIPR_CODI');
    babmc.user_login                     := v('P101_USER_LOGIN');
    babmc.user_mail                      := v('P101_USER_MAIL');
    babmc.user_nive_codi                 := v('P101_USER_NIVE_CODI');
    babmc.user_orte_codi                 := v('P101_USER_ORTE_CODI');
    babmc.user_pass                      := v('P101_USER_PASS');
    babmc.user_perf_codi                 := v('P101_USER_PERF_CODI');
    babmc.user_perf_desc_inte_codi       := v('P101_USER_PERF_DESC_INTE_CODI');
    babmc.user_secu_codi                 := v('P101_USER_SECU_CODI');
    babmc.user_spass                     := v('P101_USER_SPASS');
    babmc.user_tiem_mens                 := v('P101_USER_TIEM_MENS');
    babmc.user_toke                      := v('P101_USER_TOKE');
    babmc.user_token_fcm                 := v('P101_USER_TOKEN_FCM');
    babmc.user_upass                     := v('P101_USER_UPASS');
    babmc.user_tele                      := v('P101_USER_TELE');
    babmc.user_indi_comi_vend            := V('P101_USER_INDI_COMI_VEND');

  end pp_set_variable;

-----------------------------------------------
  procedure pp_validar is

    v_cant number;
  begin

    if babmc.user_tele is null and babmc.user_mail is null then
      raise_application_error(-20010, 'Se debe de ingresar un Numero de telefono o Email!');
    else
      --valida email
      if babmc.user_mail is not null then

        begin

          if babmc.user_codi is null then
            select count(*)
            into v_cant
            from segu_user u
            where lower(u.user_mail) = lower(babmc.user_mail);
          else
            select count(*)
            into v_cant
            from segu_user u
            where user_codi <> babmc.user_codi
            and lower(u.user_mail) = lower(babmc.user_mail);
          end if;

          if v_cant > 0 then
            raise_application_error(-20010, 'Ya existe un usuario con el mismo email!');
          end if;

        exception
          when others then
            raise_application_error(-20010, 'Error al validar email! '|| sqlerrm);
        end;

      end if;

      --valida nro telefono
      if babmc.user_tele is not null then
        begin

          if babmc.user_codi is null then
            select count(*)
            into v_cant
            from segu_user u
            where lower(u.user_tele) = lower(babmc.user_tele);
          else
            select count(*)
            into v_cant
            from segu_user u
            where user_codi <> babmc.user_codi
            and lower(u.user_tele) = lower(babmc.user_tele);
          end if;


          if v_cant > 0 then
            raise_application_error(-20010, 'Ya existe un usuario con el mismo numero de telefono!');
          end if;

        exception
          when others then
            raise_application_error(-20010, 'Error al validar numero de telefono! '|| sqlerrm);
        end;

      end if;

    end if;


  end pp_validar;

-----------------------------------------------
  procedure pp_actualizar is

    v_user       varchar2(20) := fp_user;
    v_count_mapa number;
  begin

    pp_set_variable;

    if babmc.user_desc is null then
      raise_application_error(-20001, 'Debe ingresar la descripcion');
    end if;

    if babmc.user_codi is null then

      i010014.pp_valida_login(p_user_login => babmc.user_login,
                              p_user_codi  => babmc.user_codi);

      if babmc.user_codi is null then
        if babmc.pass is null then
          raise_application_error(-20001, 'Debe especificar el Password');
        end if;
      end if;
    end if;

    if babmc.user_empl_codi is not null then
      i010014.pp_valida_repe_empl(p_empl_codi => babmc.user_empl_codi,
                                  p_user_codi => babmc.user_codi);
    end if;

    ---------pre insert

    if babmc.user_codi is null then

      ---------------------------------------
      pp_validar;

      if babmc.user_codi_orig is null then
        parameter.p_user_codi := babmc.user_codi;
        i010014.pp_valida_login(p_user_login => babmc.user_login,
                                p_user_codi  => babmc.user_codi);

  

        parameter.p_indi_abrir := 'S';

      end if;
      babmc.user_indi_modi_dato_ot_fini := nvl(babmc.user_indi_modi_dato_ot_fini,
                                               'N');
      babmc.user_indi_modi_dato_vehi    := nvl(babmc.user_indi_modi_dato_vehi,
                                               'N');
      babmc.user_indi_admi              := 'N';

      if parameter.p_indi_app_movi = 'S' then
        pa_encripta_pass(babmc.pass, babmc.user_spass, babmc.user_upass);
      end if;
      
      if parameter.p_indi_apex = 'S' then
        babmc.user_pass := my_hash(babmc.user_login, babmc.pass);
      end if;

      select nvl(max(user_codi), 0) + 1
        into babmc.user_codi
        from segu_user;

      insert into segu_user
        (user_codi,
         user_desc,
         user_login,
         user_indi_admi,
         user_base,
         user_empl_codi,
         user_mail,
         user_indi_ortr_limi_cost,
         user_indi_gene_dife_inve,
         user_indi_modi_limi_cost_inic,
         user_clpr_codi,
         user_indi_modi_buzo_cobr,
         user_user_regi,
         user_fech_regi,
         user_indi_modi_maxi_porc_clie,
         user_nive_codi,
         user_indi_proc_comi,
         user_indi_modi_cuen_cont,
         user_indi_real_deto_sin_exce,
         user_tiem_mens,
         user_indi_noti_cump_clie,
         user_indi_modi_cier_caja,
         user_indi_cier_caja_dife,
         user_upass,
         user_spass,
         user_indi_modi_dato_clie,
         user_depo_codi,
         user_indi_cobr_vend,
         user_indi_modi_soli_serv,
         user_cuen_codi_gs,
         user_cuen_codi_us,
         user_indi_modi_cier_plan_chic,
         user_indi_form_mens,
         user_auto_limi_cred,
         user_auto_situ_clie,
         user_auto_cheq_rech,
         user_auto_desc_prod,
         user_auto_anal_cred,
         user_auto_supe_vent,
         user_auto_gere_gene,
         user_indi_modi_camp_agent,
         user_indi_modi_camp_clas_clien,
         user_indi_modi_camp_cobr,
         user_indi_modi_camp_recl,
         user_indi_modi_camp_tele,
         user_indi_modi_camp_list_prec,
         user_indi_modi_camp_form_pago,
         user_indi_modi_dato_ot_fini,
         user_codi_empl_admi,
         user_indi_crea_veri_sose,
         user_indi_modi_dato_vehi,
         user_indi_borr_pres_clie,
         user_indi_app_movi_onli,
         user_indi_auto_anex,
         user_indi_modi_anex_auto,
         user_indi_cier_caja_vale_pend,
         user_secu_codi,
         user_lipr_codi,
         user_orte_codi,
         user_clcl_codi,
         user_indi_modi_inve_tele,
         user_indi_most_mens,
         user_indi_gps,
         user_indi_pane,
         user_esta_pane,
         user_fech_pane,
         user_perf_codi,
         --user_imag,
         user_perf_desc_inte_codi,
         user_pass,
         user_indi_modi_pres,
         user_fech_maxi_habi,
         user_indi_ver_cost_gast_logi,
         user_indi_borr_proc_pane_fact,
         user_agen_codi,
         user_grua_codi,
         user_indi_bloq,
         user_indi_modi_fech_orpa,
         user_indi_impr_reci_cons_inte,
         user_indi_modi_noti_clie,
         user_indi_crea_noti_clie,
         mimetype,
         filename,
         user_indi_modi_camp_desc,
         user_indi_modi_camp_ruc,
         user_indi_modi_camp_secc_exce,
         user_indi_modi_camp_situ,
         user_indi_modi_camp_form_fact,
         user_indi_modi_camp_esta,
         user_indi_gene_pre_anex_ot,
         user_indi_modi_obse_fact_deta,
         user_indi_modi_vent_comp,
         user_clre_codi,
         user_toke,
         user_indi_ver_cost_gast_perd,
         user_indi_fact_inmu_modi_inte,
         user_indi_fact_inmu_fech_dife,
         user_indi_fact_inmu_modi_nume,
         user_indi_anul_remi,
         user_indi_borr_liqu_ot,
         user_indi_impr_cons_docu,
         user_indi_des_liqu_ot,
         user_indi_borr_ot,
         user_indi_most_even,
         user_token_fcm,
         user_indi_limi_sucu_repo_vent,
         user_indi_cont_hora,
         user_indi_rel_evento,
         user_tele,
         user_indi_comi_vend)
      values
        (babmc.user_codi,
         babmc.user_desc,
         babmc.user_login,
         babmc.user_indi_admi,
         babmc.user_base,
         babmc.user_empl_codi,
         babmc.user_mail,
         babmc.user_indi_ortr_limi_cost,
         babmc.user_indi_gene_dife_inve,
         babmc.user_indi_modi_limi_cost_inic,
         babmc.user_clpr_codi,
         babmc.user_indi_modi_buzo_cobr,
         v_user,
         sysdate,
         babmc.user_indi_modi_maxi_porc_clie,
         babmc.user_nive_codi,
         babmc.user_indi_proc_comi,
         babmc.user_indi_modi_cuen_cont,
         babmc.user_indi_real_deto_sin_exce,
         babmc.user_tiem_mens,
         babmc.user_indi_noti_cump_clie,
         babmc.user_indi_modi_cier_caja,
         babmc.user_indi_cier_caja_dife,
         babmc.user_upass,
         babmc.user_spass,
         babmc.user_indi_modi_dato_clie,
         babmc.user_depo_codi,
         babmc.user_indi_cobr_vend,
         babmc.user_indi_modi_soli_serv,
         babmc.user_cuen_codi_gs,
         babmc.user_cuen_codi_us,
         babmc.user_indi_modi_cier_plan_chic,
         babmc.user_indi_form_mens,
         babmc.user_auto_limi_cred,
         babmc.user_auto_situ_clie,
         babmc.user_auto_cheq_rech,
         babmc.user_auto_desc_prod,
         babmc.user_auto_anal_cred,
         babmc.user_auto_supe_vent,
         babmc.user_auto_gere_gene,
         babmc.user_indi_modi_camp_agent,
         babmc.user_indi_modi_camp_clas_clien,
         babmc.user_indi_modi_camp_cobr,
         babmc.user_indi_modi_camp_recl,
         babmc.user_indi_modi_camp_tele,
         babmc.user_indi_modi_camp_list_prec,
         babmc.user_indi_modi_camp_form_pago,
         babmc.user_indi_modi_dato_ot_fini,
         babmc.user_codi_empl_admi,
         babmc.user_indi_crea_veri_sose,
         babmc.user_indi_modi_dato_vehi,
         babmc.user_indi_borr_pres_clie,
         babmc.user_indi_app_movi_onli,
         babmc.user_indi_auto_anex,
         babmc.user_indi_modi_anex_auto,
         babmc.user_indi_cier_caja_vale_pend,
         babmc.user_secu_codi,
         babmc.user_lipr_codi,
         babmc.user_orte_codi,
         babmc.user_clcl_codi,
         babmc.user_indi_modi_inve_tele,
         babmc.user_indi_most_mens,
         babmc.user_indi_gps,
         babmc.user_indi_pane,
         babmc.user_esta_pane,
         babmc.user_fech_pane,
         babmc.user_perf_codi,
         -- babmc.user_imag,
         babmc.user_perf_desc_inte_codi,
         babmc.user_pass,
         babmc.user_indi_modi_pres,
         babmc.user_fech_maxi_habi,
         babmc.user_indi_ver_cost_gast_logi,
         babmc.user_indi_borr_proc_pane_fact,
         babmc.user_agen_codi,
         babmc.user_grua_codi,
         babmc.user_indi_bloq,
         babmc.user_indi_modi_fech_orpa,
         babmc.user_indi_impr_reci_cons_inte,
         babmc.user_indi_modi_noti_clie,
         babmc.user_indi_crea_noti_clie,
         babmc.mimetype,
         babmc.filename,
         babmc.user_indi_modi_camp_desc,
         babmc.user_indi_modi_camp_ruc,
         babmc.user_indi_modi_camp_secc_exce,
         babmc.user_indi_modi_camp_situ,
         babmc.user_indi_modi_camp_form_fact,
         babmc.user_indi_modi_camp_esta,
         babmc.user_indi_gene_pre_anex_ot,
         babmc.user_indi_modi_obse_fact_deta,
         babmc.user_indi_modi_vent_comp,
         babmc.user_clre_codi,
         babmc.user_toke,
         babmc.user_indi_ver_cost_gast_perd,
         babmc.user_indi_fact_inmu_modi_inte,
         babmc.user_indi_fact_inmu_fech_dife,
         babmc.user_indi_fact_inmu_modi_nume,
         babmc.user_indi_anul_remi,
         babmc.user_indi_borr_liqu_ot,
         babmc.user_indi_impr_cons_docu,
         babmc.user_indi_des_liqu_ot,
         babmc.user_indi_borr_ot,
         babmc.user_indi_most_even,
         babmc.user_token_fcm,
         babmc.user_indi_limi_sucu_repo_vent,
         babmc.user_indi_cont_hora,
         babmc.user_indi_rel_evento,
         babmc.user_tele,
         babmc.user_indi_comi_vend);

    else

      --------------pre update
      pp_validar;

      babmc.user_indi_modi_dato_ot_fini := nvl(babmc.user_indi_modi_dato_ot_fini,'N');
      babmc.user_indi_modi_dato_vehi    := nvl(babmc.user_indi_modi_dato_vehi,'N');


      update segu_user
         set user_desc                      = babmc.user_desc,
             user_login                     = babmc.user_login,
             user_indi_admi                 = babmc.user_indi_admi,
             user_base                      = babmc.user_base,
             user_empl_codi                 = babmc.user_empl_codi,
             user_mail                      = babmc.user_mail,
             user_indi_ortr_limi_cost       = babmc.user_indi_ortr_limi_cost,
             user_indi_gene_dife_inve       = babmc.user_indi_gene_dife_inve,
             user_indi_modi_limi_cost_inic  = babmc.user_indi_modi_limi_cost_inic,
             user_clpr_codi                 = babmc.user_clpr_codi,
             user_indi_modi_buzo_cobr       = babmc.user_indi_modi_buzo_cobr,
             user_user_modi                 = v_user,
             user_fech_modi                 = sysdate,
             user_indi_modi_maxi_porc_clie  = babmc.user_indi_modi_maxi_porc_clie,
             user_nive_codi                 = babmc.user_nive_codi,
             user_indi_proc_comi            = babmc.user_indi_proc_comi,
             user_indi_modi_cuen_cont       = babmc.user_indi_modi_cuen_cont,
             user_indi_real_deto_sin_exce   = babmc.user_indi_real_deto_sin_exce,
             user_tiem_mens                 = babmc.user_tiem_mens,
             user_indi_noti_cump_clie       = babmc.user_indi_noti_cump_clie,
             user_indi_modi_cier_caja       = babmc.user_indi_modi_cier_caja,
             user_indi_cier_caja_dife       = babmc.user_indi_cier_caja_dife,
             user_upass                     = babmc.user_upass,
             user_spass                     = babmc.user_spass,
             user_indi_modi_dato_clie       = babmc.user_indi_modi_dato_clie,
             user_depo_codi                 = babmc.user_depo_codi,
             user_indi_cobr_vend            = babmc.user_indi_cobr_vend,
             user_indi_modi_soli_serv       = babmc.user_indi_modi_soli_serv,
             user_cuen_codi_gs              = babmc.user_cuen_codi_gs,
             user_cuen_codi_us              = babmc.user_cuen_codi_us,
             user_indi_modi_cier_plan_chic  = babmc.user_indi_modi_cier_plan_chic,
             user_indi_form_mens            = babmc.user_indi_form_mens,
             user_auto_limi_cred            = babmc.user_auto_limi_cred,
             user_auto_situ_clie            = babmc.user_auto_situ_clie,
             user_auto_cheq_rech            = babmc.user_auto_cheq_rech,
             user_auto_desc_prod            = babmc.user_auto_desc_prod,
             user_auto_anal_cred            = babmc.user_auto_anal_cred,
             user_auto_supe_vent            = babmc.user_auto_supe_vent,
             user_auto_gere_gene            = babmc.user_auto_gere_gene,
             user_indi_modi_camp_agent      = babmc.user_indi_modi_camp_agent,
             user_indi_modi_camp_clas_clien = babmc.user_indi_modi_camp_clas_clien,
             user_indi_modi_camp_cobr       = babmc.user_indi_modi_camp_cobr,
             user_indi_modi_camp_recl       = babmc.user_indi_modi_camp_recl,
             user_indi_modi_camp_tele       = babmc.user_indi_modi_camp_tele,
             user_indi_modi_camp_list_prec  = babmc.user_indi_modi_camp_list_prec,
             user_indi_modi_camp_form_pago  = babmc.user_indi_modi_camp_form_pago,
             user_indi_modi_dato_ot_fini    = babmc.user_indi_modi_dato_ot_fini,
             user_codi_empl_admi            = babmc.user_codi_empl_admi,
             user_indi_crea_veri_sose       = babmc.user_indi_crea_veri_sose,
             user_indi_modi_dato_vehi       = babmc.user_indi_modi_dato_vehi,
             user_indi_borr_pres_clie       = babmc.user_indi_borr_pres_clie,
             user_indi_app_movi_onli        = babmc.user_indi_app_movi_onli,
             user_indi_auto_anex            = babmc.user_indi_auto_anex,
             user_indi_modi_anex_auto       = babmc.user_indi_modi_anex_auto,
             user_indi_cier_caja_vale_pend  = babmc.user_indi_cier_caja_vale_pend,
             user_secu_codi                 = babmc.user_secu_codi,
             user_lipr_codi                 = babmc.user_lipr_codi,
             user_orte_codi                 = babmc.user_orte_codi,
             user_clcl_codi                 = babmc.user_clcl_codi,
             user_indi_modi_inve_tele       = babmc.user_indi_modi_inve_tele,
             user_indi_most_mens            = babmc.user_indi_most_mens,
             user_indi_gps                  = babmc.user_indi_gps,
             user_indi_pane                 = babmc.user_indi_pane,
             user_esta_pane                 = babmc.user_esta_pane,
             user_fech_pane                 = babmc.user_fech_pane,
             user_perf_codi                 = babmc.user_perf_codi,
             --user_imag                      = babmc.user_imag,
             user_perf_desc_inte_codi      = babmc.user_perf_desc_inte_codi,
             user_pass                     = babmc.user_pass,
             user_indi_modi_pres           = babmc.user_indi_modi_pres,
             user_fech_maxi_habi           = babmc.user_fech_maxi_habi,
             user_indi_ver_cost_gast_logi  = babmc.user_indi_ver_cost_gast_logi,
             user_indi_borr_proc_pane_fact = babmc.user_indi_borr_proc_pane_fact,
             user_agen_codi                = babmc.user_agen_codi,
             user_grua_codi                = babmc.user_grua_codi,
             user_indi_bloq                = babmc.user_indi_bloq,
             user_indi_modi_fech_orpa      = babmc.user_indi_modi_fech_orpa,
             user_indi_impr_reci_cons_inte = babmc.user_indi_impr_reci_cons_inte,
             user_indi_modi_noti_clie      = babmc.user_indi_modi_noti_clie,
             user_indi_crea_noti_clie      = babmc.user_indi_crea_noti_clie,
             mimetype                      = babmc.mimetype,
             filename                      = babmc.filename,
             user_indi_modi_camp_desc      = babmc.user_indi_modi_camp_desc,
             user_indi_modi_camp_ruc       = babmc.user_indi_modi_camp_ruc,
             user_indi_modi_camp_secc_exce = babmc.user_indi_modi_camp_secc_exce,
             user_indi_modi_camp_situ      = babmc.user_indi_modi_camp_situ,
             user_indi_modi_camp_form_fact = babmc.user_indi_modi_camp_form_fact,
             user_indi_modi_camp_esta      = babmc.user_indi_modi_camp_esta,
             user_indi_gene_pre_anex_ot    = babmc.user_indi_gene_pre_anex_ot,
             user_indi_modi_obse_fact_deta = babmc.user_indi_modi_obse_fact_deta,
             user_indi_modi_vent_comp      = babmc.user_indi_modi_vent_comp,
             user_clre_codi                = babmc.user_clre_codi,
             user_toke                     = babmc.user_toke,
             user_indi_ver_cost_gast_perd  = babmc.user_indi_ver_cost_gast_perd,
             user_indi_fact_inmu_modi_inte = babmc.user_indi_fact_inmu_modi_inte,
             user_indi_fact_inmu_fech_dife = babmc.user_indi_fact_inmu_fech_dife,
             user_indi_fact_inmu_modi_nume = babmc.user_indi_fact_inmu_modi_nume,
             user_indi_anul_remi           = babmc.user_indi_anul_remi,
             user_indi_borr_liqu_ot        = babmc.user_indi_borr_liqu_ot,
             user_indi_impr_cons_docu      = babmc.user_indi_impr_cons_docu,
             user_indi_des_liqu_ot         = babmc.user_indi_des_liqu_ot,
             user_indi_borr_ot             = babmc.user_indi_borr_ot,
             user_indi_most_even           = babmc.user_indi_most_even,
             user_token_fcm                = babmc.user_token_fcm,
             user_indi_limi_sucu_repo_vent = babmc.user_indi_limi_sucu_repo_vent,
             user_indi_cont_hora           = babmc.user_indi_cont_hora,
             user_indi_rel_evento          = babmc.user_indi_rel_evento,
             user_tele                     = babmc.user_tele,
             user_indi_comi_vend           = babmc.user_indi_comi_vend
       where user_codi = babmc.user_codi;
    end if;

    if babmc.user_indi_rel_evento = 'S' then

      select count(*)
        into v_count_mapa
        from mapa_user_conf t
       where t.usco_user_codi = babmc.user_codi;

      if v_count_mapa = 0 then
        insert into mapa_user_conf
          (usco_user_codi, usco_reci_even)
        values
          (babmc.user_codi, 'N');
      end if;
    else
      delete mapa_user_conf where usco_user_codi = babmc.user_codi;
    end if;

    pp_actualiza_segu_user_cuen; --despues aun no hice la modal
    pp_actualiza_segu_user_empr;
    pp_actualiza_segu_user_sucu;

  end pp_actualizar;

  procedure pp_validar_borrado is
    v_count number(6);
  begin

    --Pantallas asignadas
    select count(*)
      into v_count
      from segu_user_pant
     where uspa_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Pantallas que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    --perfiles  asignados al usuario
    select count(*)
      into v_count
      from segu_user_perf
     where uspe_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Perfiles que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    --cuentas bancarias asignadas al usuario
    select count(*)
      into v_count
      from segu_user_cuen_banc
     where uscb_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Cuentas bancarias que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    ---validar Tipo de Movimiento asignados al usuario
    select count(*)
      into v_count
      from segu_user_tipo_movi
     where usmo_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'tipos de movimientos que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    ---validar operacion de Stock asignados al usuario
    select count(*)
      into v_count
      from segu_user_stoc_oper
     where usop_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Operaciones de Stock que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    ---validar Depositos (Entradas) asignados al usuario
    select count(*)
      into v_count
      from segu_user_depo_dest
     where udes_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Depositos (+) que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    ---validar Depositos (Salidas) asignados al usuario
    select count(*)
      into v_count
      from segu_user_depo_orig
     where udor_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Depositos (-) que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    ---validar cuentas bancarias (entradas) asignados al usuario
    select count(*)
      into v_count
      from segu_user_cuen_dest
     where uscd_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Cuentas bancarias (+) que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    ---validar cuentas bancarias (salidas) asignados al usuario
    select count(*)
      into v_count
      from segu_user_cuen_orig
     where usco_user_codi = babmc.user_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Cuentas bancarias (-) que tienen asignados este Usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    --validar empresas asignadas al usuario
    /*  select count(*)
      into v_count
      from segu_user_empr
      where usem_user_codi =  :babmc.user_codi;

      if v_count > 0 then
         pl_me('Existen'||'  '||v_count||' '|| 'Empresa que tiene asignado a este Usuario. primero debe borrarlo o asignarlo a otra');
      end if;


    --validar sucursales asignadas al usuario
    select count(*)
      into v_count
      from segu_user_sucu
      where ussu_user_codi =  :babmc.user_codi;

      if v_count > 0 then
         pl_me('Existen'||'  '||v_count||' '|| 'Sucursales que tienen asignado a este Usuario. primero debes borrarlos o asignarlos a otra');
      end if;*/

  end;

  procedure pp_borrar_registro is
    v_message   varchar2(70) := '?Realmente desea Borrar el Usuario?';
    v_user_codi number := babmc.user_codi;
  begin
    pp_set_variable;

    update segu_user
       set user_base = parameter.p_codi_base
     where user_codi = babmc.user_codi;

    pp_genera_sentencia_delete;
    pp_validar_borrado;

    delete segu_user_empr where usem_user_codi = babmc.user_codi;

    delete segu_user_sucu where ussu_user_codi = babmc.user_codi;

    delete come_admi_mens_user where meus_user_codi = babmc.user_codi;

    delete segu_user_list where usli_user_codi = babmc.user_codi;

    delete mapa_user_conf where usco_user_codi = babmc.user_codi;

    delete segu_user where user_codi = babmc.user_codi;

  exception

    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_borrar_registro;

  procedure pp_llama_reporte is
    v_nombre       varchar2(50);
    v_parametros   clob;
    v_contenedores clob;

    v_user     varchar2(100) := fp_user;
    v_nro      varchar2(50);
    v_fecha    varchar2(50);
    v_deposito varchar2(50);
    v_tasa     varchar2(50);
    v_tipo     varchar2(50);

  begin

    delete from come_parametros_report where usuario = v_user;

    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, v_user, 'I010014', 'pdf', v_contenedores);

  end pp_llama_reporte;

-----------------------------------------------
  procedure pp_genera_login(i_user_desc in varchar2,
                            o_login     out varchar2) is

    v_palabra           VARCHAR2(100);
    v_longitud_nombre   NUMBER;
    v_longitud_apellido NUMBER;
    v_nombre            VARCHAR2(100);
    v_apellido          VARCHAR2(100);
    v_new_user          VARCHAR2(100);
    v_cant              number;
    v_indi              VARCHAR2(1) := 'N';
    v_aux_user          VARCHAR2(100);
    v_contador          number := 1;

  begin

    if i_user_desc is null then
      raise_application_error(-20010, 'Debe de ingresar una descripcion');
    end if;

    v_palabra := i_user_desc;

    v_longitud_nombre := LENGTH(SUBSTR(v_palabra,1,INSTR(v_palabra, ' ') - 1));
    v_apellido := upper(TRIM(SUBSTR(v_palabra, INSTR(v_palabra, ' ') + 1)));

    FOR i IN 1 .. v_longitud_nombre LOOP

      v_new_user := upper(SUBSTR(v_palabra, i, 1)) || v_apellido;
      v_aux_user := v_new_user;

      select count(*)
        into v_cant
        from segu_user
       where upper(user_login) = v_new_user;

      if v_cant = 0 then
        v_indi := 'N';
        exit;
      else
        v_indi := 'S';

      end if;

    END LOOP;

    if v_indi = 'S' then
      v_cant := 0;

      --CASO PARA APELLIDO
      v_indi := 'N';

      v_longitud_apellido := LENGTH(SUBSTR(v_palabra,INSTR(v_palabra, ' ') + 1));
      v_nombre := upper(TRIM(SUBSTR(v_palabra, 1, INSTR(v_palabra, ' ') - 1)));

      FOR i IN 1 .. v_longitud_apellido LOOP

        v_new_user := upper(SUBSTR(v_palabra, INSTR(v_palabra, ' ') + i, 1)) ||v_nombre;

        select count(*)
          into v_cant
          from segu_user
         where upper(user_login) = v_new_user;

        if v_cant = 0 then
          v_indi := 'N';
          exit;
        else
          v_indi := 'S';
        end if;

      END LOOP;

      if v_indi = 'S' then
        v_cant := 0;

        loop

          v_new_user := v_aux_user || '00' || v_contador;

          select count(*)
            into v_cant
            from segu_user
           where upper(user_login) = v_new_user;

          v_contador := v_contador + 1;

          exit when v_cant = 0;
        end loop;

      end if;

    end if;

    o_login := v_new_user;

  end pp_genera_login;

-----------------------------------------------

end i010014;
