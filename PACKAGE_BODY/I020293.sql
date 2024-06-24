
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020293" is

  p_sucu_codi number := v('AI_SUCU_CODI');
  p_empr_codi number := v('AI_EMPR_CODI');

  type t_parameter is record(
    p_clpr_indi_clie_prov varchar2(1) := 'C',
    --babmc.cheq_tipo := 'R';
    p_codi_base           number := pack_repl.fa_devu_codi_base,
    p_codi_timo_extr_banc number := to_number(fa_busc_para('p_codi_timo_extr_banc')),
    p_codi_mone_mmee      number := to_number(fa_busc_para('p_codi_mone_mmee')),
    p_cant_deci_mmee      number := to_number(fa_busc_para('p_cant_deci_mmee')),
    p_codi_conc_extr_mone number := to_number(fa_busc_para('p_codi_conc_extr_mone')),
    p_codi_impu_exen      number := to_number(fa_busc_para('p_codi_impu_exen')),
    p_codi_conc           number := to_number(fa_busc_para('p_codi_conc_cheq_cred')),
    p_fech_inic           date,
    p_fech_fini           date);
  parameter t_parameter;

  type t_cabe is record(
    clpr_codi      number,
    clpr_codi_alte number,
    cuen_codi      number,
    tarj_nume      number,
    tarj_fech_emis date,
    tacu_coti_mone number,
    tacu_impo_mmnn number,
    tacu_impo_mone number,
    TACU_CLPR_DESC varchar2(500),
    tarj_proc      number,
    tarj_nego      number,
    tarj_prod      number,
    tarj_banc_codi number,
    tarj_fech_venc date);
  babmc t_cabe;

  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

  procedure pp_actualizar_registro is
  
  begin
  
    I020293.pp_set_variable;
  
    i020293.pp_actualizar_movi;
  
    commit;
  end;

  procedure pp_actualizar_movi is
  
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           char(20);
    v_movi_codi_padr      number;
    v_movi_tasa_mone      number;
    v_movi_tasa_mmee      number;
    v_movi_grav_mmnn      number;
    v_movi_exen_mmnn      number;
    v_movi_iva_mmnn       number;
    v_movi_grav_mmee      number;
    v_movi_exen_mmee      number;
    v_movi_iva_mmee       number;
    v_movi_grav_mone      number;
    v_movi_exen_mone      number;
    v_movi_iva_mone       number;
    v_movi_clpr_desc      char(80);
    v_movi_emit_reci      char(1);
    v_movi_afec_sald      char(1);
    v_movi_dbcr           char(1);
    v_movi_empr_codi      number;
    v_movi_obse           varchar2(80);
    v_tica_codi           number;
  
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
  
    --variables para moimpo 
    v_moim_movi_codi      number;
    v_moim_nume_item      number := 0;
    v_moim_tipo           char(20);
    v_moim_cuen_codi      number;
    v_moim_dbcr           char(1);
    v_moim_afec_caja      char(1);
    v_moim_fech           date;
    v_moim_impo_mone      number;
    v_moim_impo_mmnn      number;
    v_moim_tarj_cupo_codi number;
  
    v_tacu_codi      number;
    v_tacu_tapr_codi number;
    v_tacu_tane_codi number;
    v_tacu_tade_codi number;
    v_tacu_impo_mone number;
    v_tacu_impo_mmnn number;
    v_tacu_coti_mone number;
    v_tacu_clpr_codi number;
    v_tacu_fech_emis date;
    v_tacu_fech_venc date;
    v_tacu_esta      char;
    v_tacu_base      number;
    v_tacu_tarj_nume number;
    --v_tacu_plan_codi          number;
    v_CUEN_CODI      number;
    v_tacu_user_modi char(20);
    v_tacu_fech_modi date;
    V_tarj_BANC_CODI number;
  
    v_mota_movi_codi number;
    v_mota_tacu_codi number;
    v_mota_nume_orde number;
    v_mota_base      number;
  
  begin
  
    ---insertar el movimiento de salida (origen) (extracción)
    pp_muestra_tipo_movi(parameter.p_codi_timo_extr_banc,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    v_movi_codi_padr      := null;
    v_movi_codi           := fa_sec_come_movi;
    v_movi_timo_codi      := to_number(parameter.p_codi_timo_extr_banc);
    v_movi_cuen_codi      := babmc.CUEN_CODI;
    v_movi_clpr_codi      := babmc.clpr_codi;
    v_movi_sucu_codi_orig := p_sucu_codi;
    v_movi_mone_codi      := 1;
    v_movi_nume           := babmc.tarj_nume;
    v_movi_fech_emis      := babmc.tarj_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_tasa_mone      := babmc.tacu_coti_mone;
    --busca la tasa de la moneda extranjera para la fecha de la operación
    --pp_busca_tasa_mone                (parameter.p_codi_mone_mmee, babmc.cheq_fech_emis, v_movi_tasa_mmee, v_tica_codi);
    v_movi_grav_mmnn := 0;
    v_movi_exen_mmnn := babmc.tacu_impo_mmnn;
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_exen_mmee := round(babmc.tacu_impo_mmnn / v_movi_tasa_mmee,
                              parameter.p_cant_deci_mmee);
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
    v_movi_exen_mone := babmc.tacu_impo_mone;
    v_movi_iva_mone  := 0;
    v_movi_clpr_desc := babmc.TACU_CLPR_DESC;
    v_movi_empr_codi := p_empr_codi;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_cuen_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
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
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_obse);
  
    ----actualizar moco.... 
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc;
    v_moco_dbcr      := 'C';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_movi_exen_mone;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
  
    --actualizar moim...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  v_movi_codi,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0);
  
    --insert come_tarj_cupo y come_movi_tarj_cupo 
    v_tacu_codi      := fa_sec_come_tarj_cupo;
    v_tacu_tapr_codi := babmc.tarj_proc;
    v_tacu_tane_codi := babmc.tarj_nego;
    v_tacu_tade_codi := babmc.tarj_prod;
  
    v_tacu_impo_mone := babmc.tacu_impo_mone;
    v_tacu_impo_mmnn := babmc.tacu_impo_mone; --round((babmc.tacu_impo_mone* babmc.tacu_coti_mone), parameter.p_cant_deci_mmnn);
    v_tacu_coti_mone := babmc.tacu_coti_mone;
    v_tacu_clpr_codi := babmc.clpr_codi;
  
    v_tacu_fech_emis := babmc.tarj_fech_emis;
    v_tacu_fech_venc := babmc.tarj_fech_venc;
    v_tacu_esta      := 'I'; --ingresado 
    v_tacu_base      := 1;
  
    v_tacu_tarj_nume := babmc.tarj_nume;
    -- v_tacu_plan_codi          := 1;
    v_CUEN_CODI := null;
  
    v_tacu_user_modi := substr(gen_user, 1, 10);
  
    v_tacu_fech_modi := sysdate;
  
    v_mota_movi_codi := v_movi_codi;
    v_mota_tacu_codi := v_tacu_codi; --pq no tiene estado anterior..., o sea es el primier mov. dl chque
    v_mota_nume_orde := 1; --tendrá la secuencia 1 pq es el movimiento q dio origen al cheque...
    v_mota_base      := 1;
    V_tarj_BANC_CODI := babmc.tarj_banc_codi;
  
    pp_insert_come_tarj_cupo(v_tacu_codi,
                             v_tacu_tapr_codi,
                             v_tacu_tane_codi,
                             v_tacu_tade_codi,
                             v_tacu_impo_mone,
                             v_tacu_impo_mmnn,
                             v_tacu_coti_mone,
                             v_tacu_clpr_codi,
                             v_tacu_fech_emis,
                             v_tacu_fech_venc,
                             v_tacu_esta,
                             v_tacu_base,
                             v_tacu_tarj_nume,
                             V_tarj_BANC_CODI,
                             v_CUEN_CODI,
                             v_tacu_user_modi,
                             v_tacu_fech_modi);
  
    pp_insert_come_movi_tarj_cupo(v_mota_movi_codi,
                                  v_mota_tacu_codi,
                                  v_mota_nume_orde,
                                  v_mota_base);
  
    --actualizar moimpo 
    v_moim_movi_codi      := v_movi_codi;
    v_moim_nume_item      := 1;
    v_moim_tipo           := 'Tarjeta';
    v_moim_cuen_codi      := v_movi_cuen_codi;
    v_moim_dbcr           := v_movi_dbcr;
    v_moim_afec_caja      := 'S';
    v_moim_fech           := v_movi_fech_emis;
    v_moim_impo_mone      := v_movi_exen_mone;
    v_moim_impo_mmnn      := v_movi_exen_mmnn;
    v_moim_tarj_cupo_codi := v_tacu_codi;
  
    pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                  v_moim_nume_item,
                                  v_moim_tipo,
                                  v_moim_cuen_codi,
                                  v_moim_dbcr,
                                  v_moim_afec_caja,
                                  v_moim_fech,
                                  v_moim_impo_mone,
                                  v_moim_impo_mmnn,
                                  v_moim_tarj_cupo_codi);
  
    /*  Exception
    when form_trigger_failure then
       raise form_trigger_failure;
    when others then
       pl_mostrar_error_plsql;*/
  
  end;

  procedure pp_set_variable is
  begin
    babmc.clpr_codi      := v('P66_CLPR_CODI');
    babmc.clpr_codi_alte := v('P66_CLPR_CODI_ALTE');
    babmc.cuen_codi      := v('P66_CUEN_CODI');
    babmc.tarj_nume      := v('P66_TARJ_NUME');
    babmc.tarj_fech_emis := v('P66_S_TARJ_FECH_EMIS');
    babmc.tacu_coti_mone := v('P66_TACU_COTI_MONE');
    babmc.tacu_impo_mmnn := v('P66_TACU_IMPO_MMNN');
    babmc.tacu_impo_mone := v('P66_TACU_IMPO_MONE');
    babmc.tacu_clpr_desc := v('P66_TACU_CLPR_DESC');
    babmc.tarj_proc      := v('P66_TARJ_PROC');
    babmc.tarj_nego      := v('P66_TARJ_NEGO');
    babmc.tarj_prod      := v('P66_TARJ_PROD');
    babmc.tarj_banc_codi := v('P66_TARJ_BANC_CODI');
    babmc.tarj_fech_venc := v('P66_S_TARJ_FECH_VENC');
  
  end;

  procedure pp_validar_clie_prov(p_busc_dato           in varchar2,
                                 p_clpr_indi_clie_prov in varchar2,
                                 p_clpr_codi_alte      out number) is
    salir  exception;
    v_cant number;
  begin
    --buscar cliente/proveedor por codigo de alternativo
    if fp_buscar_clie_prov_alte(p_busc_dato,
                                p_clpr_indi_clie_prov,
                                p_clpr_codi_alte) then
      raise salir;
    end if;
  
    --buscar cliente/proveedor por ruc
    if fp_buscar_clie_prov_ruc(p_busc_dato,
                               p_clpr_indi_clie_prov,
                               p_clpr_codi_alte) then
      raise salir;
    end if;
  
    begin
      select count(*)
        into v_cant
        from come_clie_prov cp
       where cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov
            --and nvl(cp.clpr_esta, 'A') = 'A'
         and (upper(cp.clpr_codi_alte) like '%' || p_busc_dato || '%' or
             upper(cp.clpr_ruc) like '%' || p_busc_dato || '%' or
             upper(cp.clpr_desc) like '%' || p_busc_dato || '%');
    end;
  
    if v_cant >= 1 then
      --si existe al menos un cliente/proveedor con esos criterios entonces mostrar la lista 
    
      babmc.clpr_codi := null; --para ver si se acepto un valor o no despues del list_values
    
      if babmc.clpr_codi_alte is not null then
        if fp_buscar_clie_prov_alte(babmc.clpr_codi_alte,
                                    p_clpr_indi_clie_prov,
                                    p_clpr_codi_alte) then
          raise salir; --o si o si se encuentra
        end if;
      end if;
    end if;
  
    if p_clpr_indi_clie_prov = 'C' then
      pl_me('Cliente inexistente');
    else
      pl_me('Proveedor inexistente');
    end if;
  
  exception
    when salir then
      null;
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_muestra_tipo_movi(p_timo_codi      in number,
                                 p_timo_afec_sald out char,
                                 p_timo_emit_reci out char,
                                 p_timo_dbcr      out char,
                                 p_tica_codi      out number) is
  begin
  
    select timo_afec_sald, timo_emit_reci, timo_dbcr, timo_tica_codi
      into p_timo_afec_sald, p_timo_emit_reci, p_timo_dbcr, p_tica_codi
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  exception
    when no_data_found then
      p_timo_afec_sald := null;
      p_timo_emit_reci := null;
      p_timo_dbcr      := null;
      pl_me('Tipo de Movimiento inexistente');
    when too_many_rows then
      pl_me('Tipo de Movimiento duplicado');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_muestra_come_tarj_proc(p_tapr_codi in number,
                                      p_tapr_desc out varchar2) is
  begin
    select tapr_desc
      into p_tapr_desc
      from come_tarj_proc
     where tapr_codi = p_tapr_codi;
  exception
    when no_data_found then
      p_tapr_desc := null;
      pl_me('Procesadora inexistente.');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_muestra_come_tarj_deta(p_tapr_codi      in number,
                                      p_tade_codi      in number,
                                      p_tade_desc      out varchar2,
                                      p_tade_dias_venc out number) is
  begin
    select tade_desc, nvl(tade_dias_venc, 0)
      into p_tade_desc, p_tade_dias_venc
      from come_tarj_deta
     where tade_codi = p_tade_codi
       and tade_tapr_codi = p_tapr_codi;
  exception
    when no_data_found then
      p_tade_desc := null;
      pl_me('Tarjeta inexistente o no corresponde a la Procesadora seleccionada.');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_muestra_come_tarj_nego(p_tapr_codi in number,
                                      p_tane_codi in number,
                                      p_tane_nume out number) is
  begin
    select tane_nume
      into p_tane_nume
      from come_tarj_nego
     where tane_codi = p_tane_codi
       and tade_tapr_codi = p_tapr_codi
       and tade_sucu_codi = p_sucu_codi;
  exception
    when no_data_found then
      p_tane_nume := null;
      pl_me('Negocio inexistente o no corresponde a la Procesadora seleccionada.');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_valida_fech(p_fech in date) is
  begin
  
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
      pl_me('La fecha del movimiento debe estar comprendida entre..' ||
            to_char(parameter.p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
            to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end;

  procedure pp_insert_come_movi(p_movi_codi           in number,
                                p_movi_timo_codi      in number,
                                p_movi_cuen_codi      in number,
                                p_movi_clpr_codi      in number,
                                p_movi_sucu_codi_orig in number,
                                p_movi_mone_codi      in number,
                                p_movi_nume           in number,
                                p_movi_fech_emis      in date,
                                p_movi_fech_grab      in date,
                                p_movi_user           in char,
                                p_movi_codi_padr      in number,
                                p_movi_tasa_mone      in number,
                                p_movi_tasa_mmee      in number,
                                p_movi_grav_mmnn      in number,
                                p_movi_exen_mmnn      in number,
                                p_movi_iva_mmnn       in number,
                                p_movi_grav_mmee      in number,
                                p_movi_exen_mmee      in number,
                                p_movi_iva_mmee       in number,
                                p_movi_grav_mone      in number,
                                p_movi_exen_mone      in number,
                                p_movi_iva_mone       in number,
                                p_movi_clpr_desc      in char,
                                p_movi_emit_reci      in char,
                                p_movi_afec_sald      in char,
                                p_movi_dbcr           in char,
                                p_movi_empr_codi      in number,
                                p_movi_obse           in varchar2) is
  begin
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_cuen_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
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
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_base,
       movi_obse)
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_cuen_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
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
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_empr_codi,
       parameter.p_codi_base,
       p_movi_obse);
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

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
       moco_dbcr,
       moco_base)
    values
      (p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_dbcr,
       parameter.p_codi_base);
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

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
      pl_me(sqlerrm);
  end;

  procedure pp_insert_come_tarj_cupo(p_tacu_codi      number,
                                     p_tacu_tapr_codi number,
                                     p_tacu_tane_codi number,
                                     p_tacu_tade_codi number,
                                     p_tacu_impo_mone number,
                                     p_tacu_impo_mmnn number,
                                     p_tacu_coti_mone number,
                                     p_tacu_clpr_codi number,
                                     p_tacu_fech_emis date,
                                     p_tacu_fech_venc date,
                                     p_tacu_esta      char,
                                     p_tacu_base      number,
                                     p_tacu_tarj_nume number,
                                     p_tacu_banc_codi number,
                                     p_tacu_caja_CODI number,
                                     p_tacu_user_modi char,
                                     p_tacu_fech_modi date) is
  
  begin
    insert into come_tarj_cupo
      (tacu_codi,
       tacu_tapr_codi,
       tacu_tane_codi,
       tacu_tade_codi,
       tacu_impo_mone,
       tacu_impo_mmnn,
       tacu_coti_mone,
       tacu_clpr_codi,
       tacu_fech_emis,
       tacu_fech_venc,
       tacu_esta,
       tacu_base,
       tacu_tarj_nume,
       tacu_banc_codi,
       tacu_caja_CODI,
       tacu_user_modi,
       tacu_fech_modi)
    values
      (p_tacu_codi,
       p_tacu_tapr_codi,
       p_tacu_tane_codi,
       p_tacu_tade_codi,
       p_tacu_impo_mone,
       p_tacu_impo_mmnn,
       p_tacu_coti_mone,
       p_tacu_clpr_codi,
       p_tacu_fech_emis,
       p_tacu_fech_venc,
       p_tacu_esta,
       p_tacu_base,
       p_tacu_tarj_nume,
       p_tacu_banc_codi,
       p_tacu_caja_CODI,
       p_tacu_user_modi,
       p_tacu_fech_modi);
  end;

  procedure pp_insert_come_movi_tarj_cupo(p_mota_movi_codi in number,
                                          p_mota_tacu_codi in number,
                                          p_mota_nume_orde in number,
                                          p_mota_base      in number) is
  
  begin
    insert into come_movi_tarj_cupo
      (mota_movi_codi, mota_tacu_codi, mota_nume_orde, mota_base)
    values
      (p_mota_movi_codi, p_mota_tacu_codi, p_mota_nume_orde, p_mota_base);
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi      in number,
                                          p_moim_nume_item      in number,
                                          p_moim_tipo           in char,
                                          p_moim_cuen_codi      in number,
                                          p_moim_dbcr           in char,
                                          p_moim_afec_caja      in char,
                                          p_moim_fech           in date,
                                          p_moim_impo_mone      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_moim_tarj_cupo_codi in number) is
  begin
    insert into come_movi_impo_deta
      (moim_movi_codi,
       moim_nume_item,
       moim_tipo,
       moim_cuen_codi,
       moim_dbcr,
       moim_afec_caja,
       moim_fech,
       moim_impo_mone,
       moim_impo_mmnn,
       moim_tarj_cupo_codi,
       moim_form_pago,
       moim_base)
    values
      (p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       p_moim_tarj_cupo_codi,
       3,
       parameter.p_codi_base);
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pl_muestra_come_clpr(p_ind_clpr       in char,
                                 p_clpr_codi_alte in number,
                                 p_clpr_desc      out char,
                                 p_clpr_codi      out char) is
    v_tipo_razo varchar2(1);
  begin
    select nvl(clpr_desc, '0'), clpr_codi, clpr_tipo_razo
      into p_clpr_desc, p_clpr_codi, v_tipo_razo
      from come_clie_prov
     where clpr_codi_alte = p_clpr_codi_alte
       and clpr_indi_clie_prov = p_ind_clpr;
  
    if p_clpr_desc = '0' then
      if v_tipo_razo = 'F' then
        select upper(clpr_nomb) || ' ' || upper(clpr_apel)
          into p_clpr_desc
          from come_clie_prov
         where clpr_codi = p_clpr_codi;
      
      else
        select clpr_empr
          into p_clpr_desc
          from come_clie_prov
         where clpr_codi = p_clpr_codi;
      end if;
    end if;
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      p_clpr_codi := null;
      if p_ind_clpr = 'P' then
        pl_me('Proveedor inexistente!');
      elsif p_ind_clpr = 'C' then
        pl_me('Cliente inexistente!');
      else
        pl_me('Propietarios inexistente!');
      end if;
    when others then
      pl_me(sqlerrm);
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
  
  exception
    when no_data_found then
      p_cuen_desc := null;
      p_banc_codi := null;
      p_banc_desc := null;
      pl_me('Cuenta Bancaria Inexistente');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pl_vali_cier_caja(p_cuen_codi      in number,
                              p_fech           in date default sysdate,
                              p_indi_cier_caja in char) is
    v_cant      number;
    v_cant_movi number;
    v_hora_oper date;
    v_hora_sist date;
  
    v_indi_vali_cier_caja varchar2(30);
  begin
  
    v_indi_vali_cier_caja := ltrim(rtrim(fa_busc_para('p_indi_vali_cier_caja')));
  
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
              -- Si la hora paso las 9 de la mañana
              pl_me('No se puede realizar operaciones hasta realizar el cierre de Caja ' ||
                    p_cuen_codi || ' de fecha ' ||
                    to_char((trunc(p_fech) - 1), 'dd-mm-yyyy')); --'del dia anterior');
            end if;
          
          end if;
        
        end if;
      end if;
    end if;
  end;

  procedure pl_vali_cier_caja_oper(p_cuen_codi in number,
                                   p_fech      in date default sysdate) is
    v_cant number;
  
    v_indi_vali_cier_caja varchar2(30);
    v_cant_cier_caja      number := 0;
  begin
  
    v_indi_vali_cier_caja := ltrim(rtrim(fa_busc_para('p_indi_vali_cier_caja')));
    v_cant_cier_caja      := ltrim(rtrim(fa_busc_para('p_cant_cier_caja')));
  
    if nvl(upper(v_indi_vali_cier_caja), 'N') = 'S' then
      --Verifica si existe cierre en la fecha que se quiere cargar el movimiento.
      select count(*)
        into v_cant
        from come_cier_caja c
       where c.caja_cuen_codi = p_cuen_codi
         and c.caja_fech = trunc(p_fech);
    
      if v_cant > 0 and v_cant >= v_cant_cier_caja then
        -- Si ya se realizaron todos los cierres correspondientes, no debe permitir ingresar mas movimientos.      
        pl_me('No se puede realizar operaciones en esta caja. Existe(n) ' ||
              v_cant ||
              ' cierre(s) de caja para la fecha de operación cargada.');
      end if;
    end if;
  end;

  function fp_buscar_clie_prov_alte(p_busc_dato           in varchar2,
                                    p_clpr_indi_clie_prov in varchar2,
                                    p_clpr_codi_alte      out number)
    return boolean is
    v_clpr_esta varchar2(1);
  begin
    select cp.clpr_codi_alte, nvl(cp.clpr_esta, 'A')
      into p_clpr_codi_alte, v_clpr_esta
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov
       and cp.clpr_codi_alte = p_busc_dato;
  
    if v_clpr_esta <> 'A' then
      if p_clpr_indi_clie_prov = 'C' then
        pl_me('El cliente se encuentra en estado INACTIVO');
      else
        pl_me('El proveedor se encuentra en estado INACTIVO');
      end if;
    end if;
  
    return true;
  
  exception
    when no_data_found then
      return false;
    when invalid_number then
      return false;
    when others then
      return false;
  end;

  function fp_buscar_clie_prov_ruc(p_busc_dato           in varchar2,
                                   p_clpr_indi_clie_prov in varchar2,
                                   p_clpr_codi_alte      out number)
    return boolean is
    v_clpr_esta varchar2(1);
  begin
    select cp.clpr_codi_alte, nvl(cp.clpr_esta, 'A')
      into p_clpr_codi_alte, v_clpr_esta
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov
       and cp.clpr_ruc = p_busc_dato;
  
    if v_clpr_esta <> 'A' then
      if p_clpr_indi_clie_prov = 'C' then
        pl_me('El cliente se encuentra en estado INACTIVO');
      else
        pl_me('El proveedor se encuentra en estado INACTIVO');
      end if;
    end if;
  
    return true;
  
  exception
    when no_data_found then
      return false;
    when invalid_number then
      return false;
    when others then
      return false;
  end;

  --El objetivo de este procedimiento es validar que el usuario posea el........ 
  --permiso correspondiente para transferir una caja determintada a otra...
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que está por debajo del nivl de pantallas.....................

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
       and upper(rtrim(ltrim(u.user_login))) = upper(gen_user)
       and usco_cuen_codi = p_cuen_codi
       and uc.usco_cuen_codi = c.cuen_codi;
  
    pl_vali_cier_caja(p_cuen_codi, p_fech, v_indi_cier_caja);
    pl_vali_cier_caja_oper(p_cuen_codi, p_fech_oper);
  
    return true;
  
  exception
    when no_data_found then
      return false;
    when others then
      pl_me(sqlerrm);
  end;

end I020293;
