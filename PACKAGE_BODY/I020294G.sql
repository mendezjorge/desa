
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020294G" is

  -- Private type declarations
  type r_bsel is record(
       sose_empr_codi number,
       empr_desc varchar2(100),
       empr_colo varchar2(1),
       clpr_codl_alte varchar2(30),
       clpr_desc varchar2(100),
       clpr_codi number,
       s_fech varchar2(12),
       fech date,
       s_sode_nume varchar2(12),
       s_sode_codi number
  );
  bsel r_bsel;


  type r_babmc is record(
     sode_codi number,
     sode_nume varchar2(20),
     sode_fech_emis date,
     sode_clpr_codi number,
     clpr_codi_alte varchar2(20),
     clpr_desc varchar2(100),
     sode_sucu_nume_item number,
     sode_vehi_codi number,
     s_sucu_desc varchar2(100),
     s_sose_nume varchar2(20),
     sode_anex_codi number,
     s_anex_nume varchar2(20),
     sode_deta_nume_item number,
     s_deta_iden varchar2(60),
     s_deta_nume_pate varchar2(20),
     s_deta_mode varchar2(50),
     sode_user_regi varchar2(20),
     sode_fech_regi varchar2(50),--timestamp,
     sode_user_modi varchar2(20),
     sode_fech_modi varchar2(50),--date,
     sode_esta varchar2(1),
     sode_esta_orig varchar2(1),
     sode_base number,
     s_sode_tipo_moti varchar2(100),
     sode_tipo_moti varchar2(5),
     sode_deta_codi number,
     sode_moti varchar2(100)
  );
  babmc r_babmc;

  type r_parameter is record(
       p_codi number,
       p_empr_codi number,
       p_codi_base number,
       p_indi_most_mens_sali varchar2(30),
       p_codi_tipo_empl_vend number
  );
  parameter r_parameter;

-----------------------------------------------
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

-----------------------------------------------
  procedure pl_mm(i_mensaje varchar2) is
  begin
    pl_me(i_mensaje);
  end pl_mm;

-----------------------------------------------
  procedure pp_validar_clie_prov(p_clpr_codi in number) is
    salir exception;
    v_cant number;
  begin

    --buscar cliente/proveedor por codigo de alternativo
    if p_clpr_codi is not null then
      select count(*)
        into v_cant
        from come_clie_prov
       where clpr_codi = p_clpr_codi;

      if v_cant = 1 then
        raise salir;
      else
        pl_me('Cliente inexistente');
      end if;
    else
      raise salir;
    end if;

  exception
    when salir then
      null;
    when others then
      raise_application_error(-20010, 'Erro al validar Cliente! ' || sqlerrm);
  end pp_validar_clie_prov;


-----------------------------------------------
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
      p_clpr_desc      := null;
      p_clpr_codi_alte := null;
      pl_me('Cliente Inexistente');
    when others then
      pl_me('Error al buscar detalles de Cliente!' || sqlerrm);
  end pp_muestra_come_clie_prov;

-----------------------------------------------
  procedure pp_muestra_come_clpr_sub_cuen(p_clpr_codi      in number,
                                          p_sucu_nume_item in number) is
  begin
    select sucu_desc
      into babmc.s_sucu_desc
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi
       and sucu_nume_item = p_sucu_nume_item;
  exception
    when no_data_found then
      pl_me('SubCuenta Inexistente');
    when others then
      pl_me('Error al buscar SubCuenta! '||sqlerrm);

  end pp_muestra_come_clpr_sub_cuen;

-----------------------------------------------
  procedure pp_muestra_come_soli_serv_anex(p_sode_codi in number) is
  begin
    select anex_nume,
           sose_nume,
           vehi_iden      deta_iden,
           vehi_nume_pate deta_nume_pate,
           vehi_mode      deta_mode
      into babmc.s_anex_nume,
           babmc.s_sose_nume,
           babmc.s_deta_iden,
           babmc.s_deta_nume_pate,
           babmc.s_deta_mode
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
      pl_me('Solicitud de Desinstalación Inexistente');
    when others then
      pl_me('Error al validar Solicitud de Desinstalación! ' || sqlerrm);
  end pp_muestra_come_soli_serv_anex;

-----------------------------------------------
  procedure pp_veri_ot_sode is

    v_ortr_nume      number;
    v_ortr_desc      varchar2(500);
    v_ortr_codi_padr number;

  begin

    select ortr_nume, ortr_desc, ortr_codi_padr
      into v_ortr_nume, v_ortr_desc, v_ortr_codi_padr
      from come_orde_trab t
     where ortr_sode_codi = babmc.sode_codi;

    if v_ortr_codi_padr is not null then
      pl_mm('No se podrán realizar cambios a la Solicitud, porque fue generada desde la OT ' ||
            v_ortr_nume || ' por ' || v_ortr_desc);

      /*
        if get_item_property('bpie.aceptar', enabled) = 'TRUE' then
          set_item_property('bpie.aceptar', enabled, property_false);
        end if;
      else
        if get_item_property('bpie.aceptar', enabled) = 'FALSE' then
          set_item_property('bpie.aceptar', enabled, property_true);
          set_item_property('bpie.aceptar', navigable, property_true);
        end if;*/
    end if;

  exception
    when no_data_found then
      null;
  end pp_veri_ot_sode;

-----------------------------------------------
  procedure pp_send_values is

  begin

    setitem('P125_SODE_CODI',babmc.sode_codi);
    setitem('P125_SODE_NUME',babmc.sode_nume);
    setitem('P125_SODE_FECH_EMIS', babmc.sode_fech_emis);
    setitem('P125_SODE_CLPR_CODI',babmc.sode_clpr_codi);
    --setitem('P125_SODE_SUCU_NUME_ITEM',babmc.sode_sucu_nume_item);
    --setitem('P125_SODE_VEHI_CODI', babmc.sode_vehi_codi);
    --setitem('P125_SODE_ANEX_CODI', babmc.sode_anex_codi);
    --setitem('P125_SODE_DETA_NUME_ITEM', babmc.sode_deta_nume_item);
    setitem('P125_SODE_USER_REGI', babmc.sode_user_regi);
    setitem('P125_SODE_FECH_REGI', babmc.sode_fech_regi);
    setitem('P125_SODE_USER_MODI', babmc.sode_user_modi);
    setitem('P125_SODE_FECH_MODI', babmc.sode_fech_modi);
    setitem('P125_SODE_ESTA', babmc.sode_esta);
    --setitem('P125_SODE_BASE', babmc.sode_base);
    --setitem('P125_SODE_TIPO_MOTI', babmc.sode_tipo_moti);
    --setitem('P125_SODE_DETA_CODI', babmc.sode_deta_codi);
    setitem('P125_SODE_MOTI', babmc.sode_moti);

    --setitem('', );
    setitem('P125_CLPR_CODI_ALTE_D', babmc.clpr_codi_alte||' - '||babmc.clpr_desc );
    if babmc.sode_sucu_nume_item is not null then
      setitem('P125_SODE_SUCU_NUME_ITEM',(babmc.sode_sucu_nume_item ||' - '|| babmc.s_sucu_desc));
    end if;
    setitem('P125_S_SOSE_NUME', babmc.s_sose_nume);
    setitem('P125_S_ANEX_NUME', babmc.s_anex_nume);
    setitem('P125_S_DETA_IDEN', babmc.s_deta_iden);
    setitem('P125_S_DETA_NUME_PATE', babmc.s_deta_nume_pate);
    setitem('P125_S_DETA_MODE', babmc.s_deta_mode);
    setitem('P125_S_SODE_TIPO_MOTI', babmc.s_sode_tipo_moti);

    setitem('P125_SODE_ESTA_ORIG', babmc.sode_esta_orig);
    setitem('P125_SODE_DETA_CODI', babmc.sode_deta_codi);


  end;
-----------------------------------------------
  procedure pp_ejecutar_consulta_nume is

    v_sode_codi number;
    v_sode_esta varchar2(1);

  begin

    select sode_codi, sode_esta
      into v_sode_codi, v_sode_esta
      from come_soli_desi
     where nvl(sode_tipo_moti, 'O') = 'G' --Solicitud de Desinst de Grua
       and (sode_clpr_codi = bsel.clpr_codi or bsel.clpr_codi is null)
       and (sode_fech_emis = bsel.fech or bsel.fech is null)
       and (sode_nume = bsel.s_sode_nume or bsel.s_sode_nume is null);

    if v_sode_esta = 'L' then
      pl_mm('La Solicitud de desinstalación ya ha sido Liquidada.');

      /*if get_item_property('bpie.aceptar', enabled) = 'TRUE' then
        set_item_property('bpie.aceptar', enabled, property_false);
      end if; */
    end if;

    /*go_block('babmc');
    clear_block(no_validate);
    set_block_property('babmc',default_where, ' sode_codi = '||to_char(v_sode_codi));
    execute_query;*/
    select sode_codi,
         sode_nume,
         sode_fech_emis,
         sode_clpr_codi,
         sode_sucu_nume_item,
         sode_vehi_codi,
         sode_anex_codi,
         sode_deta_nume_item,
         sode_user_regi,
         to_char(sode_fech_regi, 'DD/MM/YYYY HH24:MI:SS'),
         sode_user_modi,
         to_char(sode_fech_modi, 'DD/MM/YYYY HH24:MI:SS'),
         sode_esta,
         sode_base,
         sode_tipo_moti,
         sode_deta_codi,
         sode_moti
    into babmc.sode_codi,
         babmc.sode_nume,
         babmc.sode_fech_emis,
         babmc.sode_clpr_codi,
         babmc.sode_sucu_nume_item,
         babmc.sode_vehi_codi,
         babmc.sode_anex_codi,
         babmc.sode_deta_nume_item,
         babmc.sode_user_regi,
         babmc.sode_fech_regi,
         babmc.sode_user_modi,
         babmc.sode_fech_modi,
         babmc.sode_esta,
         babmc.sode_base,
         babmc.sode_tipo_moti,
         babmc.sode_deta_codi,
         babmc.sode_moti
    from come_soli_desi
   where sode_codi = v_sode_codi;

   ---
    babmc.sode_esta_orig := babmc.sode_esta;

    if babmc.sode_clpr_codi is not null then
      pp_muestra_come_clie_prov(babmc.sode_clpr_codi, babmc.clpr_desc, babmc.clpr_codi_alte);
    end if;

    if babmc.sode_sucu_nume_item is not null then
      pp_muestra_come_clpr_sub_cuen(babmc.sode_clpr_codi, babmc.sode_sucu_nume_item);
    end if;

    if babmc.sode_codi is not null then
      pp_muestra_come_soli_serv_anex(babmc.sode_codi);
    end if;

    if babmc.sode_tipo_moti is not null then
      if babmc.sode_tipo_moti = 'R' then
        babmc.s_sode_tipo_moti := 'Reinstalación';
      elsif babmc.sode_tipo_moti = 'N' then
        babmc.s_sode_tipo_moti := 'No Renovación';
      elsif babmc.sode_tipo_moti = 'C' then
        babmc.s_sode_tipo_moti := 'Rescisión';
      elsif babmc.sode_tipo_moti = 'E' then
        babmc.s_sode_tipo_moti := 'Recupero de Equipo';
      elsif babmc.sode_tipo_moti = 'Z' then
        babmc.s_sode_tipo_moti := 'No Renovación de Poliza';
      elsif babmc.sode_tipo_moti = 'CT' then
        babmc.s_sode_tipo_moti := 'Por Cambio de Titularidad';
      elsif babmc.sode_tipo_moti = 'CR' then
        babmc.s_sode_tipo_moti := 'Por Cambio de Seguro a RPY';
      elsif babmc.sode_tipo_moti = 'CS' then
        babmc.s_sode_tipo_moti := 'Por Cambio de Seguro a Seguro';
      elsif babmc.sode_tipo_moti = 'CRAS' then
        babmc.s_sode_tipo_moti := 'Por Cambio de RPY a Seguro';
      elsif babmc.sode_tipo_moti = 'G' then
        babmc.s_sode_tipo_moti := 'Desinstalación de Grúa';
      elsif babmc.sode_tipo_moti = 'O' then
        babmc.s_sode_tipo_moti := 'Otros no definidos';
      end if;
    end if;

    pp_veri_ot_sode;

   ---




   pp_send_values();


  end;

-----------------------------------------------
  procedure pp_ejecutar_consulta(i_clpr_codi in number,
                                 i_fech      in varchar2,
                                 i_s_sode_nume in number) is

    v_count number := 0;

  begin

    if i_s_sode_nume is null then
      pl_me('Debe de seleccionar una Solicitud de desinstalacion!');
    end if;
    ---
    bsel.clpr_codi := i_clpr_codi;
    bsel.fech := to_date(i_fech, 'dd/mm/yyyy');
    bsel.s_sode_nume := i_s_sode_nume;
    ---
    select count(*)
      into v_count
      from come_soli_desi
     where nvl(sode_tipo_moti, 'O') = 'G' --solicitud de desinst de grua
       and (sode_clpr_codi = bsel.clpr_codi or bsel.clpr_codi is null)
       and (sode_fech_emis = bsel.fech or bsel.fech is null)
       and (sode_nume = bsel.s_sode_nume or bsel.s_sode_nume is null);

    if v_count > 1 then
      pl_me('Existe más de una solicitud para este cliente, por favor seleccione uno!');
    elsif v_count = 1 then
      pp_ejecutar_consulta_nume;
    else
      pl_me('Solicitud de Desinstalación de Grúa Inexistente.');
    end if;
  end pp_ejecutar_consulta;

-----------------------------------------------
  procedure pp_valida_fact_anex(p_sode_deta_codi in number) is

    cursor c_plan(p_nume_item in number, p_anex_codi in number) is
      select nvl(anpl_deta_esta_plan, 'N') anpl_deta_esta_plan
        from come_soli_serv_anex_plan
       where anpl_nume_item = p_nume_item
         and anpl_anex_codi = p_anex_codi
       order by anpl_nume_item;

    v_indi_si_plan varchar2(1) := 'N';
    v_indi_no_plan varchar2(1) := 'N';

    v_anpl_nume_item number;
    v_anpl_anex_codi number;

  begin

    select min(anpl_nume_item), anpl_anex_codi
      into v_anpl_nume_item, v_anpl_anex_codi
      from come_soli_serv_anex_plan
     where anpl_deta_codi = p_sode_deta_codi
       and anpl_deta_esta_plan = 'N'
     group by anpl_anex_codi;

    for x in c_plan(v_anpl_nume_item, v_anpl_anex_codi) loop
      if x.anpl_deta_esta_plan = 'S' then
        v_indi_si_plan := 'S';
      elsif x.anpl_deta_esta_plan = 'N' then
        v_indi_no_plan := 'S';
      end if;
    end loop;

    if v_indi_si_plan = 'S' and v_indi_no_plan = 'S' then
      pl_me('No se puede modificar Estado de Solicitud, ya se realizo facturaciones luego de Autorizarse.');
    end if;
  end pp_valida_fact_anex;

-----------------------------------------------
  procedure pp_eliminar_anex_ot(p_sode_codi in number) is

    cursor c_ortr is
      select o.ortr_codi
        from come_orde_trab o
       where o.ortr_sode_codi = p_sode_codi;

    v_cant number;

  begin

    for y in c_ortr loop

      begin
        select count(*)
          into v_cant
          from come_orde_trab
         where ortr_codi = y.ortr_codi
           and (ortr_esta = 'L' or ortr_esta_pre_liqu = 'S');

        if v_cant > 0 then
          pl_me('No se puede cambiar estado de la Solicitud, posee OT que ya se encuentran Pre-liquidadas o Liquidadas!.');
        end if;
      end;

      delete come_orde_trab_vehi where vehi_ortr_codi = y.ortr_codi;
      delete come_orde_trab_cont where cont_ortr_codi = y.ortr_codi;
      delete come_orde_trab where ortr_codi = y.ortr_codi;
    end loop;

  end pp_eliminar_anex_ot;

-----------------------------------------------
  procedure pp_validar is
    v_count number := 0;
  begin

    if babmc.sode_esta <> babmc.sode_esta_orig then

      if babmc.sode_esta = 'L' then
        pl_me('No se puede Liquidar una solicitud de Desinstalación de Grúa desde éste programa!');

      elsif babmc.sode_esta in ('P', 'R') then

        if babmc.sode_esta_orig = 'A' then --si estaba autorizado se verifica que no se haya facturado algo
          pp_valida_fact_anex(babmc.sode_deta_codi);

        end if;

        pp_eliminar_anex_ot(babmc.sode_codi);

      end if;
    end if;
  end pp_validar;

-----------------------------------------------
  procedure pp_generar_mensaje is

    v_ortr_codi number;
    v_ortr_nume number;
    v_clpr_desc varchar2(100);
    v_count     number;

  begin
    if babmc.sode_esta <> babmc.sode_esta_orig then
      if babmc.sode_esta in ('P', 'R') then
        update come_soli_serv_anex_deta d
           set d.deta_esta_plan = 'S'
         where deta_codi = babmc.sode_deta_codi;

        update come_soli_serv_anex_plan p
           set p.anpl_deta_esta_plan = 'S'
         where p.anpl_deta_codi = babmc.sode_deta_codi
           and p.anpl_indi_fact = 'N';

      elsif babmc.sode_esta = 'A' then
        update come_soli_serv_anex_deta d
           set d.deta_esta_plan = 'N'
         where deta_codi = babmc.sode_deta_codi;

        update come_soli_serv_anex_plan p
           set p.anpl_deta_esta_plan = 'N'
         where p.anpl_deta_codi = babmc.sode_deta_codi
           and p.anpl_indi_fact = 'N';

        begin
          select c.clpr_desc
            into v_clpr_desc
            from come_clie_prov c
           where c.clpr_codi = babmc.sode_clpr_codi;
        exception
          when others then
            v_clpr_desc := null;
        end;

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
           ('Se ha Autorizado la Solicitud de Desinstalación de Grúa Nro. ' ||
           babmc.sode_nume || ' para el Cliente ' || v_clpr_desc ||
           ', con fecha de emisión ' || babmc.sode_fech_emis || '.'),
           babmc.sode_user_regi,
           babmc.sode_user_modi,
           sysdate,
           'N',
           null,
           null);
      end if;
    end if;
  end pp_generar_mensaje;

-----------------------------------------------
  procedure pp_update_registro is

  begin

    update come_soli_desi
      set sode_esta = babmc.sode_esta,
          sode_user_modi = gen_user,
          sode_fech_modi = sysdate
    where sode_codi = babmc.sode_codi;

  exception
    when others then
      pl_me('Error al actualizar registro!.');

  end pp_update_registro;

-----------------------------------------------
  procedure pp_validar_items(i_clpr_codi in number) is

  begin
    pp_validar_clie_prov(i_clpr_codi);

  end pp_validar_items;

-----------------------------------------------
  procedure pp_actualizar_registro(i_clpr_codi in number) is

  begin

    pp_validar_items(i_clpr_codi);

    pp_veri_ot_sode;
    --go_block('babmc');


    pp_update_registro;

    pp_generar_mensaje;

    apex_application.g_print_success_message:= 'Registro actualizado.!';


    /*
    commit_form;

    if not form_success then
       clear_block(no_validate);
       message('Registro no actualizado.');
    else
       message('Registro actualizado.');
       clear_block(no_validate);
       go_block('bsel');
       clear_block(no_validate);
    end if;
    if form_failure then
       raise form_trigger_failure;
    end if;*/

  exception
    when others then
      pl_me('Registro no actualizado.');

  end pp_actualizar_registro;

-----------------------------------------------
  procedure pp_cargar_parametros is

  begin
    parameter.p_codi_base           := pack_repl.fa_devu_codi_base;
    parameter.p_indi_most_mens_sali := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_most_mens_sali'))));
    parameter.p_codi_tipo_empl_vend := ltrim(rtrim((general_skn.fl_busca_parametro('p_codi_tipo_empl_vend'))));

  end pp_cargar_parametros;

-----------------------------------------------
  procedure pp_ejecutar_consulta_codi is

    v_sode_esta varchar2(1);
    v_sode_codi number;

  begin
    select sode_codi, sode_esta
      into v_sode_codi, v_sode_esta
      from come_soli_desi
     where sode_codi = bsel.s_sode_codi;

    if v_sode_esta = 'L' then
      pl_me('La Solicitud de desinstalación ya ha sido Liquidada.');
    end if;

    /*go_block('babmc');
    clear_block(no_validate);
    set_block_property('babmc',default_where,' sode_codi = ' || to_char(v_sode_codi));
    execute_query;
    */

  end pp_ejecutar_consulta_codi;

-----------------------------------------------
  procedure pp_iniciar is
  begin
    pp_cargar_parametros;

    if bsel.sose_empr_codi is null then
      bsel.sose_empr_codi := parameter.p_empr_codi;
    end if;

    /*if bsel.sose_empr_codi is not null then
      pl_muestra_come_empr(bsel.sose_empr_codi, bsel.empr_desc);
      bsel.empr_colo := fp_devu_color(bsel.sose_empr_codi);
      pl_asig_color('bsel.sose_empr_codi', bsel.empr_colo);
      pl_asig_color('bsel.empr_desc', bsel.empr_colo);
    end if;*/

    if parameter.p_codi is not null then
      bsel.s_sode_codi := parameter.p_codi;
      pp_ejecutar_consulta_codi;
      parameter.p_codi := null;
    end if;

    /*
    if get_item_property('bpie.aceptar', enabled) = 'FALSE' then
      set_item_property('bpie.aceptar', enabled, property_true);
      set_item_property('bpie.aceptar', navigable, property_true);
    end if;*/

  end pp_iniciar;

-----------------------------------------------
  procedure pp_btn_actualizar(i_sode_esta in varchar2,
                              i_sode_esta_orig in varchar2,
                              i_sode_deta_codi in number,
                              i_sode_codi in number,
                              i_clpr_codi in number,

                              i_sode_clpr_codi in number,
                              i_sode_nume in varchar2,
                              i_sode_fech_emis in varchar2,
                              i_sode_user_regi in varchar2,
                              i_sode_user_modi in varchar2
                              ) is

  begin

    bsel.clpr_codi := i_clpr_codi;
    babmc.sode_esta:= i_sode_esta;
    babmc.sode_esta_orig := i_sode_esta_orig;
    babmc.sode_deta_codi := i_sode_deta_codi;
    if i_sode_codi is null then
      pl_me('No se ha seleccionado ningun registro!.');
    else
      babmc.sode_codi := i_sode_codi;
    end if;

    babmc.sode_clpr_codi := i_sode_clpr_codi;
    babmc.sode_nume      := i_sode_nume;
    babmc.sode_fech_emis := i_sode_fech_emis;
    babmc.sode_user_regi := i_sode_user_regi;
    babmc.sode_user_modi := i_sode_user_modi;


    pp_validar;
    pp_actualizar_registro(bsel.clpr_codi);
    /*pp_iniciar*/



  end;
-----------------------------------------------


end I020294G;
