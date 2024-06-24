
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020233" is

  type t_parameter is record(
    p_cant_deci_mmnn      number := to_number(fa_busc_para('p_cant_deci_mmnn')),
    p_cant_deci_mmee      number := to_number(fa_busc_para('p_cant_deci_mmee')),
    p_indi_most_mens_sali varchar2(400) := rtrim(ltrim(fa_busc_para('p_indi_most_mens_sali'))),
    p_codi_tipo_empl_vend number := to_number(fa_busc_para('p_codi_tipo_empl_vend')),
    p_form_clie_buzo_cobr varchar2(400) := rtrim(ltrim(fa_busc_para('p_form_clie_buzo_cobr'))),
    p_form_cons_stoc      varchar2(400) := rtrim(ltrim(fa_busc_para('p_form_cons_stoc'))),
    p_codi_base           number := pack_repl.fa_devu_codi_base);
  parameter t_parameter;

  type t_cabe is record(
    tacu_esta        varchar2(1),
    s_fech_emis      date,
    s_fech_venc      date,
    clpr_codi        number,
    tade_codi        number,
    tapr_codi        number,
    cuen_codi        number,
    movi_nume        number,
    s_fech_emis_tarj date,
    
    tacu_codi_1       number,
    tacu_tapr_codi_1  number,
    tacu_tarje_nume_1 number,
    tacu_fech_emis_1  date,
    tacu_fech_venc_1  date,
    tacu_plan_codi_1  number);

  bsel t_cabe;

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
  
    i020233.pp_set_variable;
  
    if v('P67_INDI_ACTU') = 'U' then
      update come_tarj_cupo
         set tacu_tapr_codi = bsel.tacu_tapr_codi_1,
             tacu_fech_emis = bsel.tacu_fech_emis_1,
             tacu_fech_venc = bsel.tacu_fech_venc_1,
             tacu_tarj_nume = bsel.tacu_tarje_nume_1,
             tacu_plan_codi = bsel.tacu_plan_codi_1
       where tacu_codi = bsel.tacu_codi_1;
    
    end if;
  end;

  procedure pp_set_variable is
  begin
    bsel.tacu_esta        := v('P67_TACU_ESTA');
    bsel.s_fech_emis      := v('P67_S_FECH_EMIS');
    bsel.s_fech_venc      := v('P67_S_FECH_VENC');
    bsel.clpr_codi        := v('P67_CLPR_CODI');
    bsel.tade_codi        := v('P67_TADE_CODI');
    bsel.tapr_codi        := v('P67_TAPR_CODI');
    bsel.cuen_codi        := v('P67_CUEN_CODI');
    bsel.movi_nume        := v('P67_MOVI_NUME');
    bsel.s_fech_emis_tarj := v('P67_S_FECH_EMIS_TARJ');
  
    bsel.tacu_codi_1       := v('P67_TACU_CODI_1');
    bsel.tacu_tapr_codi_1  := v('P67_TAPR_CODI_1');
    bsel.tacu_tarje_nume_1 := v('P67_TACU_TARJE_NUME_1');
    bsel.tacu_fech_emis_1  := v('P67_S_FECH_EMIS_1');
    bsel.tacu_fech_venc_1  := v('P67_S_FECH_VENC_1');
    bsel.tacu_plan_codi_1  := v('P67_TACU_PLAN_CODI_1');
  
  end;

  procedure pp_mostrar_cuen_banc(p_cuen_codi in number,
                                 p_cuen_desc out varchar2,
                                 p_cuen_nume out varchar2,
                                 p_banc_codi out number,
                                 p_banc_desc out varchar2) is
  begin
    select c.cuen_desc, c.cuen_nume, b.banc_codi, b.banc_desc
      into p_cuen_desc, p_cuen_nume, p_banc_codi, p_banc_desc
      from come_cuen_banc c, come_banc b
     where c.cuen_banc_codi = b.banc_codi(+)
       and c.cuen_codi = p_cuen_codi;
  
  exception
    when no_data_found then
      p_cuen_desc := null;
      p_cuen_nume := null;
      p_banc_codi := null;
      p_banc_desc := null;
      pl_me('Cuenta inexistente');
    when others then
      pl_me(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' || sqlerrm);
  end;

  procedure pp_mostrar_clie_prov(p_clpr_codi_alte      in number,
                                 p_clpr_indi_clie_prov in varchar2,
                                 p_clpr_codi           out number,
                                 p_clpr_desc           out varchar2) is
  begin
    select cp.clpr_codi, cp.clpr_desc
      into p_clpr_codi, p_clpr_desc
      from come_clie_prov cp
     where cp.clpr_codi_alte = p_clpr_codi_alte
       and cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov;
  
  exception
    when no_data_found then
      p_clpr_codi := null;
      p_clpr_desc := null;
      if p_clpr_indi_clie_prov = 'C' then
        pl_me('Cliente inexistente');
      else
        pl_me('Proveedor inexistente');
      end if;
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_mostrar_tarj_proc(p_tapr_codi in number,
                                 p_tapr_desc out varchar2) is
  begin
    select p.tapr_desc
      into p_tapr_desc
      from come_tarj_proc p
     where p.tapr_codi = p_tapr_codi;
  
  exception
    when no_data_found then
      p_tapr_desc := null;
      --pl_me('Procesadora inexistente');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_mostrar_tarj_deta(p_tade_codi in number,
                                 p_tade_desc out varchar2) is
  begin
    select t.tade_desc
      into p_tade_desc
      from come_tarj_deta t
     where t.tade_codi = p_tade_codi;
  
  exception
    when no_data_found then
      p_tade_desc := null;
    --  pl_me('Tarjeta inexistente');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_ejecutar_consulta is
    v_where varchar2(2000);
    v_sql   varchar2(32000);
  begin
  
    i020233.pp_set_variable;
  
    if bsel.tacu_esta = 'I' then
      v_where := ' and tacu_esta = ' || chr(39) || 'I' || chr(39);
    elsif bsel.tacu_esta = 'D' then
      v_where := ' and tacu_esta = ' || chr(39) || 'D' || chr(39);
    elsif bsel.tacu_esta = 'L' then
      v_where := 'and tacu_esta = ' || chr(39) || 'L' || chr(39);
    elsif bsel.tacu_esta = 'T' then
      v_where := 'and 1 = 1';
    end if;
  
    if bsel.s_fech_emis is not null then
      v_where := v_where || ' and tacu_fech_emis = ' || chr(39) ||
                 bsel.s_fech_emis || chr(39);
    end if;
    if bsel.s_fech_venc is not null then
      v_where := v_where || ' and tacu_fech_venc = ' || chr(39) ||
                 bsel.s_fech_venc || chr(39);
    end if;
    if bsel.clpr_codi is not null then
      v_where := v_where || ' and tacu_clpr_codi = ' || bsel.clpr_codi;
    end if;
    if bsel.tade_codi is not null then
      v_where := v_where || ' and tacu_tade_codi = ' || bsel.tade_codi;
    end if;
    if bsel.tapr_codi is not null then
      v_where := v_where || ' and tacu_tapr_codi = ' || bsel.tapr_codi;
    end if;
    if bsel.cuen_codi is not null then
      v_where := v_where || ' and exists (select moim_movi_codi ' ||
                 'from come_movi_impo_deta ' ||
                 'where moim_tarj_cupo_codi = tacu_codi ' ||
                 'and moim_cuen_codi = ' || bsel.cuen_codi || ')';
    end if;
    if bsel.movi_nume is not null then
      v_where := v_where || ' and exists (select movi_codi ' ||
                 'from come_movi,come_movi_tarj_cupo ' ||
                 'where movi_codi = mota_movi_codi ' ||
                 'and mota_tacu_codi = tacu_codi ' || 'and movi_nume=' ||
                 bsel.movi_nume || ')';
    end if;
    if bsel.s_fech_emis_tarj is not null then
      v_where := v_where || ' and exists (select moim_movi_codi ' ||
                 'from come_movi_impo_deta ' ||
                 'where moim_tarj_cupo_codi = tacu_codi ' ||
                 'and moim_fech = ' || chr(39) || bsel.s_fech_emis_tarj ||
                 chr(39) || ')';
    end if;
  
    v_sql := '    
select a.tacu_codi,
       a.tacu_tarj_nume,
       c.clpr_codi_alte,
       c.clpr_desc,
       c.clpr_indi_clie_prov,
       a.tacu_fech_emis,
       a.tacu_fech_venc,
       a.tacu_impo_mone,
       t.tapr_codi,
       t.tapr_desc,
       td.tade_codi,
       td.tade_desc,
       cuenta.moim_cuen_codi,
       cuenta.cuen_desc,
       cuenta.cuen_nume,
       cuenta.banc_desc,
       movi.movi_nume,
       tp.plan_desc,
       tp.plan_dias_venc,
       tp.plan_cant_cuot,
       sucu.sucu_codi,
       sucu.sucu_desc,
       tp.plan_codi,
       a.tacu_user_modi,
       a.tacu_fech_modi,
       a.tacu_esta
  from come_tarj_cupo a,
       come_clie_prov c,
       come_tarj_proc t,
       come_tarj_deta td,
       come_plan_tarj tp,
       (select d.moim_cuen_codi,
               c.cuen_desc,
               c.cuen_nume,
               b.banc_desc,
               t.tacu_codi
          from come_movi_impo_deta d,
               come_tarj_cupo      t,
               come_cuen_banc      c,
               come_banc           b
         where d.moim_tarj_cupo_codi = t.tacu_codi
           and d.moim_cuen_codi = c.cuen_codi(+)
           and c.cuen_banc_codi = b.banc_codi(+)
           and t.tacu_esta = ''I''
           and cuen_nume is not null
         group by d.moim_cuen_codi,
                  c.cuen_desc,
                  c.cuen_nume,
                  b.banc_desc,
                  t.tacu_codi) cuenta,
       (select m.movi_nume, t.tacu_codi
          from come_movi m, come_movi_tarj_cupo mt, come_tarj_cupo t
         where m.movi_codi = mt.mota_movi_codi
           and mt.mota_tacu_codi = t.tacu_codi
           and t.tacu_esta = ''I'') movi,
       (select s.sucu_codi, s.sucu_desc, n.tade_tapr_codi
          from come_tarj_nego n, come_sucu s
         where n.tade_sucu_codi = s.sucu_codi) sucu
 where a.tacu_clpr_codi = c.clpr_codi
   and a.tacu_tapr_codi = t.tapr_codi(+)
   and a.tacu_tade_codi = td.tade_codi(+)
   and a.tacu_codi = cuenta.tacu_codi(+)
   and a.tacu_codi = movi.tacu_codi(+)
   and a.tacu_plan_codi = tp.plan_codi(+)
   and a.tacu_tapr_codi = sucu.tade_tapr_codi(+) 
' || v_where;
  
    --   insert into come_concat (campo1, otro) values (v_sql, 'query tarjeta');
  
    if APEX_COLLECTION.COLLECTION_EXISTS(p_collection_name => 'I020233') then
      APEX_COLLECTION.DELETE_COLLECTION('I020233');
    end if;
  
    apex_collection.create_collection_from_query(p_collection_name => 'I020233',
                                                 p_query           => v_sql,
                                                 p_generate_md5    => 'YES');
  
  end;

  procedure pp_redefinir_plan(p_tacu_codi      in number,
                              p_plan_codi      in number,
                              p_tacu_tapr_codi in number,
                              p_tacu_tade_codi in number,
                              p_tacu_fech_emis in date,
                              p_tacu_tane_codi in number) is
  
    v_tacu_codi      number(20);
    v_tacu_tapr_codi number(20);
    v_tacu_tane_codi number(20);
    v_tacu_tade_codi number(20);
    v_tacu_impo_mone number(20, 4);
    v_tacu_impo_mmnn number(20, 4);
    v_tacu_coti_mone number(20, 4);
    v_tacu_clpr_codi number(20);
    v_tacu_fech_emis date;
    v_tacu_fech_venc date;
    v_tacu_esta      varchar2(1);
    v_tacu_base      number(5);
    v_tacu_tarj_nume number(20);
    v_tacu_caja_codi number(20);
    v_tacu_user_modi varchar2(20);
    v_tacu_fech_modi date;
    v_tacu_plan_codi number(10);
    v_tacu_codi_padr number(20);
  
    v_moim_movi_codi      number(20);
    v_moim_nume_item      number(4);
    v_moim_tipo           varchar2(20);
    v_moim_cuen_codi      number(4);
    v_moim_dbcr           varchar2(1);
    v_moim_afec_caja      varchar2(1);
    v_moim_fech           date;
    v_moim_impo_mone      number(20, 4);
    v_moim_impo_mmnn      number(20, 4);
    v_moim_base           number(2);
    v_moim_cheq_codi      number(20);
    v_moim_caja_codi      number(20);
    v_moim_impo_mmee      number(20, 4);
    v_moim_asie_codi      number(20);
    v_moim_fech_oper      date;
    v_moim_tarj_cupo_codi number(20);
    v_moim_movi_codi_vale number(20);
    v_moim_form_pago      number(10);
  
    v_mota_movi_codi number(20);
    v_mota_tacu_codi number(20);
    v_mota_esta_ante varchar2(1);
    v_mota_nume_orde number(20);
    v_mota_base      number(5);
  
    v_tacu_codi_padr_orig number;
    v_tacu_plan_codi_orig number;
    v_tota_impo_mone      number;
    v_tota_impo_mmnn      number;
    v_plan_dias_venc_orig number;
    v_plan_cant_cuot_orig number;
    v_plan_dias_venc      number;
    v_plan_cant_cuot      number;
    v_nuev_fech_venc      date;
    v_nuev_impo_mone      number;
    v_nuev_impo_mmnn      number;
    v_parc_impo_mone      number;
    v_parc_impo_mmnn      number;
    v_cant                number;
    v_mone_cant_deci      number;
    v_caja_nume           number;
    v_caja_fech           date;
  
    salir exception;
  
    cursor c_hijo is
      select c.tacu_codi
        from come_tarj_cupo c
       where c.tacu_codi_padr = p_tacu_codi
       order by c.tacu_codi;
  
    cursor c_moim(p_moim_movi_codi in number) is
      select i.moim_movi_codi, i.moim_nume_item
        from come_movi_impo_deta i
       where i.moim_movi_codi = p_moim_movi_codi
       order by i.moim_nume_item;
  
    cursor cDeta is
      select c001 tacu_codi
        from apex_collections
       where collection_name = 'I020233'
         and seq_id = v('P67_CODIGO');
  
  begin
  
    begin
      select tacu_tapr_codi,
             tacu_tane_codi,
             tacu_tade_codi,
             tacu_coti_mone,
             tacu_clpr_codi,
             tacu_fech_emis,
             tacu_esta,
             tacu_tarj_nume,
             tacu_caja_codi,
             tacu_plan_codi,
             tacu_codi_padr
        into v_tacu_tapr_codi,
             v_tacu_tane_codi,
             v_tacu_tade_codi,
             v_tacu_coti_mone,
             v_tacu_clpr_codi,
             v_tacu_fech_emis,
             v_tacu_esta,
             v_tacu_tarj_nume,
             v_tacu_caja_codi,
             v_tacu_plan_codi_orig,
             v_tacu_codi_padr_orig
        from come_tarj_cupo
       where tacu_codi = p_tacu_codi;
    exception
      when no_data_found then
        pl_me('Cupon inexistente');
    end;
  
    if v_tacu_plan_codi = p_plan_codi then
      raise salir;
    end if;
  
    if v_tacu_codi_padr_orig is not null then
      pl_me('No se puede modificar el Plan de un Cupon hijo. Debe modificar el Cupon Padre');
    end if;
  
    select count(*)
      into v_cant
      from come_tarj_cupo c
     where c.tacu_codi_padr = p_tacu_codi
       and c.tacu_esta <> 'I';
  
    if v_cant > 0 then
      pl_me('Existen cupones dependientes de este que ya no estan en estado Ingresado');
    end if;
  
    if v_tacu_caja_codi is not null then
      begin
        select c.caja_nume, c.caja_fech
          into v_caja_nume, v_caja_fech
          from come_cier_caja c
         where c.caja_codi = v_tacu_caja_codi;
        pl_me('No se puede redifinir el plan por tener cierre de caja ' ||
              v_caja_nume || ' en fecha ' ||
              to_char(v_caja_fech, 'dd-mm-yyyy'));
      exception
        when no_data_found then
          null;
      end;
    end if;
  
    begin
      select p.plan_dias_venc, p.plan_cant_cuot
        into v_plan_dias_venc, v_plan_cant_cuot
        from come_plan_tarj p
       where p.plan_codi = p_plan_codi;
    exception
      when no_data_found then
        pl_me('Plan de Pago inexistente');
    end;
  
    begin
      select p.plan_dias_venc, p.plan_cant_cuot
        into v_plan_dias_venc_orig, v_plan_cant_cuot_orig
        from come_plan_tarj p
       where p.plan_codi = v_tacu_plan_codi_orig;
    exception
      when no_data_found then
        pl_me('Plan de Pago original inexistente');
    end;
  
    if v_plan_cant_cuot = v_plan_cant_cuot_orig then
      v_nuev_fech_venc := p_tacu_fech_emis + v_plan_dias_venc;
      update come_tarj_cupo c
         set c.tacu_fech_emis = p_tacu_fech_emis,
             c.tacu_fech_venc = v_nuev_fech_venc,
             c.tacu_plan_codi = p_plan_codi,
             c.tacu_tane_codi = p_tacu_tane_codi
       where c.tacu_codi = p_tacu_codi;
    
      for k in c_hijo loop
        v_nuev_fech_venc := v_nuev_fech_venc + v_plan_dias_venc;
        update come_tarj_cupo c
           set c.tacu_fech_emis = p_tacu_fech_emis,
               c.tacu_fech_venc = v_nuev_fech_venc,
               c.tacu_plan_codi = p_plan_codi,
               c.tacu_tane_codi = p_tacu_tane_codi
         where c.tacu_codi = k.tacu_codi;
      end loop;
    
      v_tacu_codi := p_tacu_codi;
    else
      select sum(c.tacu_impo_mone), sum(c.tacu_impo_mmnn)
        into v_tota_impo_mone, v_tota_impo_mmnn
        from come_tarj_cupo c
       where c.tacu_codi = p_tacu_codi
          or c.tacu_codi_padr = p_tacu_codi;
    
      begin
        select i.moim_movi_codi,
               i.moim_cuen_codi,
               i.moim_dbcr,
               i.moim_afec_caja,
               i.moim_fech,
               i.moim_cheq_codi,
               max(i.moim_caja_codi),
               i.moim_asie_codi,
               i.moim_fech_oper,
               i.moim_movi_codi_vale,
               i.moim_form_pago,
               m.mone_cant_deci
          into v_moim_movi_codi,
               v_moim_cuen_codi,
               v_moim_dbcr,
               v_moim_afec_caja,
               v_moim_fech,
               v_moim_cheq_codi,
               v_moim_caja_codi,
               v_moim_asie_codi,
               v_moim_fech_oper,
               v_moim_movi_codi_vale,
               v_moim_form_pago,
               v_mone_cant_deci
          from come_movi_impo_deta i, come_cuen_banc c, come_mone m
         where i.moim_cuen_codi = c.cuen_codi
           and c.cuen_mone_codi = m.mone_codi
           and i.moim_tarj_cupo_codi = p_tacu_codi
         group by i.moim_movi_codi,
                  i.moim_cuen_codi,
                  i.moim_dbcr,
                  i.moim_afec_caja,
                  i.moim_fech,
                  i.moim_cheq_codi,
                  i.moim_asie_codi,
                  i.moim_fech_oper,
                  i.moim_movi_codi_vale,
                  i.moim_form_pago,
                  m.mone_cant_deci;
      exception
        when no_data_found then
          pl_me('No se encontro detalle de importes');
      end;
    
      begin
        select max(i.moim_nume_item)
          into v_moim_nume_item
          from come_movi_impo_deta i
         where i.moim_movi_codi = v_moim_movi_codi;
      exception
        when no_data_found then
          pl_me('No se encontro detalle de importes');
      end;
    
      if v_moim_caja_codi is not null then
        begin
          select c.caja_nume, c.caja_fech
            into v_caja_nume, v_caja_fech
            from come_cier_caja c
           where c.caja_codi = v_moim_caja_codi;
          pl_me('No se puede redifinir el plan por tener cierre de caja ' ||
                v_caja_nume || ' en fecha ' ||
                to_char(v_caja_fech, 'dd-mm-yyyy'));
        exception
          when no_data_found then
            null;
        end;
      end if;
    
      begin
        select m.mota_movi_codi, m.mota_esta_ante, m.mota_nume_orde
          into v_mota_movi_codi, v_mota_esta_ante, v_mota_nume_orde
          from come_movi_tarj_cupo m
         where m.mota_tacu_codi = p_tacu_codi;
      exception
        when no_data_found then
          pl_me('No se encontro relacion con comprobantes');
      end;
    
      v_tacu_codi_padr := null;
      v_nuev_fech_venc := p_tacu_fech_emis;
      v_nuev_impo_mone := round(v_tota_impo_mone / v_plan_cant_cuot,
                                v_mone_cant_deci);
      v_nuev_impo_mmnn := round(v_tota_impo_mmnn / v_plan_cant_cuot,
                                parameter.p_cant_deci_mmnn);
      for k in 1 .. v_plan_cant_cuot loop
        v_nuev_fech_venc := v_nuev_fech_venc + v_plan_dias_venc;
        v_parc_impo_mone := nvl(v_parc_impo_mone, 0) + v_nuev_impo_mone;
        v_parc_impo_mmnn := nvl(v_parc_impo_mmnn, 0) + v_nuev_impo_mmnn;
        if k = v_plan_cant_cuot then
          v_nuev_impo_mone := v_nuev_impo_mone +
                              (v_tota_impo_mone - v_parc_impo_mone);
          v_nuev_impo_mmnn := v_nuev_impo_mmnn +
                              (v_tota_impo_mmnn - v_parc_impo_mmnn);
        end if;
      
        v_tacu_codi      := fa_sec_come_tarj_cupo;
        v_tacu_tapr_codi := p_tacu_tapr_codi;
        v_tacu_tade_codi := p_tacu_tade_codi;
        v_tacu_plan_codi := p_plan_codi;
        v_tacu_impo_mone := v_nuev_impo_mone;
        v_tacu_impo_mmnn := v_nuev_impo_mmnn;
        v_tacu_fech_emis := p_tacu_fech_emis;
        v_tacu_fech_venc := v_nuev_fech_venc;
        v_tacu_tane_codi := nvl(p_tacu_tane_codi, v_tacu_tane_codi);
        v_tacu_base      := parameter.p_codi_base;
        v_tacu_user_modi := gen_user;
        v_tacu_fech_modi := sysdate;
      
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
           tacu_caja_codi,
           tacu_user_modi,
           tacu_fech_modi,
           tacu_plan_codi,
           tacu_codi_padr)
        values
          (v_tacu_codi,
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
           v_tacu_caja_codi,
           v_tacu_user_modi,
           v_tacu_fech_modi,
           v_tacu_plan_codi,
           v_tacu_codi_padr);
      
        if k = 1 then
          v_tacu_codi_padr := v_tacu_codi;
        end if;
      
        v_moim_nume_item      := v_moim_nume_item + 1;
        v_moim_tipo           := 'Tarjeta             ';
        v_moim_impo_mone      := v_tacu_impo_mone;
        v_moim_impo_mmnn      := v_tacu_impo_mmnn;
        v_moim_base           := parameter.p_codi_base;
        v_moim_impo_mmee      := null;
        v_moim_tarj_cupo_codi := v_tacu_codi;
      
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
           moim_base,
           moim_cheq_codi,
           moim_caja_codi,
           moim_impo_mmee,
           moim_asie_codi,
           moim_fech_oper,
           moim_tarj_cupo_codi,
           moim_movi_codi_vale,
           moim_form_pago)
        values
          (v_moim_movi_codi,
           v_moim_nume_item,
           v_moim_tipo,
           v_moim_cuen_codi,
           v_moim_dbcr,
           v_moim_afec_caja,
           v_moim_fech,
           v_moim_impo_mone,
           v_moim_impo_mmnn,
           v_moim_base,
           v_moim_cheq_codi,
           v_moim_caja_codi,
           v_moim_impo_mmee,
           v_moim_asie_codi,
           v_moim_fech_oper,
           v_moim_tarj_cupo_codi,
           v_moim_movi_codi_vale,
           v_moim_form_pago);
      
        v_mota_tacu_codi := v_tacu_codi;
        v_mota_base      := parameter.p_codi_base;
      
        insert into come_movi_tarj_cupo
          (mota_movi_codi,
           mota_tacu_codi,
           mota_esta_ante,
           mota_nume_orde,
           mota_base)
        values
          (v_mota_movi_codi,
           v_mota_tacu_codi,
           v_mota_esta_ante,
           v_mota_nume_orde,
           v_mota_base);
      
      end loop;
    
      for k in c_hijo loop
        delete come_movi_tarj_cupo m where m.mota_tacu_codi = k.tacu_codi;
        delete come_movi_impo_deta i
         where i.moim_tarj_cupo_codi = k.tacu_codi;
        delete come_tarj_cupo c where c.tacu_codi = k.tacu_codi;
      end loop;
      delete come_movi_tarj_cupo m where m.mota_tacu_codi = p_tacu_codi;
      delete come_movi_impo_deta i
       where i.moim_tarj_cupo_codi = p_tacu_codi;
      delete come_tarj_cupo c where c.tacu_codi = p_tacu_codi;
    
      v_moim_nume_item := 0;
      for k in c_moim(v_moim_movi_codi) loop
        v_moim_nume_item := v_moim_nume_item + 1;
        update come_movi_impo_deta i
           set i.moim_nume_item = v_moim_nume_item
         where i.moim_movi_codi = k.moim_movi_codi
           and i.moim_nume_item = k.moim_nume_item;
      end loop;
    end if;
  
    for u in cDeta loop
      if v_tacu_codi = u.tacu_codi then
        exit;
      end if;
    
    end loop;
  
  exception
    when salir then
      null;
    when others then
      pl_me(sqlerrm);
  end;

end I020233;
