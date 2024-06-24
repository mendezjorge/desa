
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020286G_A" is

  -- Private type declarations
  type r_babmc is record(
      sode_empr_codi number,
      empr_desc varchar2(100),
      sode_codi number,
      empr_colo varchar2(1),
      sode_nume number,
      s_sode_fech_emis varchar2(12),
      sode_fech_emis date,
      sode_clpr_codi number,
      clpr_codi_alte varchar2(20),
      clpr_desc varchar2(100),
      clpr_clie_clas1_codi number,
      sode_sucu_nume_item number,
      s_sucu_tele varchar2(100),
      s_sucu_desc varchar2(100),
      s_indi_vali_subc varchar2(1),
      vehi_iden varchar2(60),
      sode_anex_codi number,
      sode_deta_codi number,
      sode_deta_nume_item number,
      sode_vehi_codi number,
      vehi_marc varchar2(100),
      vehi_mode varchar2(100),
      vehi_nume_pate varchar2(100),
      vehi_fech_vige_inic date,
      vehi_fech_vige_fini date,
      sode_tipo_moti varchar2(5),
      sode_moti varchar2(100),
      sode_user_regi varchar2(20),
      sode_fech_regi varchar2(50), 
      sode_user_modi varchar2(20),
      sode_fech_modi varchar2(50), 
      sode_base number,
      sode_esta varchar2(1),
      w_indi_oper varchar2(1)
  );
  babmc r_babmc;
  
  type r_parameter is record(
       p_empr_codi number,
       p_codi_base number := pack_repl.fa_devu_codi_base
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

-----------------------------------------------validar
  procedure pp_genera_nume( i_sode_empr_codi in number,
                            o_sode_nume out number) is
  begin
    
    select nvl(max(sode_nume), 0) + 1
      into o_sode_nume
      from come_soli_desi
     where sode_empr_codi = i_sode_empr_codi;--v('AI_EMPR_CODI');
    
  exception
    when others then
      pl_me('Error al generar Nro. Solicitud!');
  end pp_genera_nume;
  
-----------------------------------------------
  procedure pp_validar_nro_soli(i_sode_nume      in number,
                                i_sode_empr_codi in number,
                                o_sode_codi      out number) is
    
  begin
    
    select sode_codi
      into o_sode_codi
      from come_soli_desi
     where sode_nume = i_sode_nume
       and nvl(sode_empr_codi, 1) = nvl(i_sode_empr_codi, 1)
       and nvl(sode_tipo_moti, 'O') = 'G';
    
  exception
    when no_data_found then
      o_sode_codi := null;
      
  end pp_validar_nro_soli;

-----------------------------------------------
    procedure pp_vali_nro_soli(i_sode_nume      in number,
                               i_sode_empr_codi in number) is
      
    v_sode_codi number;
    
    begin
      
      select sode_codi
        into v_sode_codi
        from come_soli_desi
       where sode_nume = i_sode_nume
         and nvl(sode_empr_codi, 1) = nvl(i_sode_empr_codi, 1)
         and nvl(sode_tipo_moti, 'O') = 'G';
      
    exception
      when no_data_found then
        v_sode_codi := null;
        
    end pp_vali_nro_soli;
  
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
  procedure pp_muestra_clie_clas1(p_clpr_codi            in number,
                                  p_clpr_clie_clas1_codi out number) is
  begin
    select clpr_clie_clas1_codi
      into p_clpr_clie_clas1_codi
      from come_clie_prov
     where clpr_codi = p_clpr_codi
       and clpr_indi_clie_prov = 'C';

  exception
    when no_data_found then
      pl_me('Cliente Inexistente');
    when others then
      pl_me('Error al buscar SubCuenta!. ' || sqlerrm);
  end pp_muestra_clie_clas1;

-----------------------------------------------
  procedure pp_validar_sub_cuenta(i_sode_clpr_codi in number,
                                  o_indi_vali_subc out varchar2) is
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = i_sode_clpr_codi;

    if v_count > 0 then
      o_indi_vali_subc := 'S';
    else
      --:babmc.sode_sucu_nume_item := null;
      --:babmc.s_sucu_desc := null;
      o_indi_vali_subc := 'N';
    end if;

  end pp_validar_sub_cuenta;

-----------------------------------------------
  procedure pp_muestra_clie_vehi(p_vehi_codi      in varchar2,
                                 o_vehi_nume_pate out varchar2,
                                 o_vehi_marc      out varchar2,
                                 o_vehi_mode      out varchar2) is

    v_clpr_codi           number;
    v_sose_sucu_nume_item number;
    v_count               number;
    v_deta_esta           varchar2(1);
    v_vehi_esta_vehi      varchar2(1);

  begin
    select vehi_codi                deta_vehi_codi,
           vehi_clpr_codi           sose_clpr_codi,
           vehi_nume_pate           deta_nume_pate,
           vehi_mode                deta_mode,
           mave_desc,
           vehi_fech_vige_inic,
           vehi_fech_vige_fini,
           vehi_clpr_sucu_nume_item sose_sucu_nume_item
      into babmc.sode_vehi_codi,
           v_clpr_codi,
           babmc.vehi_nume_pate,
           babmc.vehi_mode,
           babmc.vehi_marc,
           babmc.vehi_fech_vige_inic,
           babmc.vehi_fech_vige_fini,
           v_sose_sucu_nume_item
      from come_marc_vehi, come_vehi
     where vehi_mave_codi = mave_codi(+)
       and vehi_codi = p_vehi_codi;
       
       o_vehi_nume_pate := babmc.vehi_nume_pate;
       o_vehi_marc      := babmc.vehi_marc;
       o_vehi_mode      := babmc.vehi_mode;

    /*
    if :babmc.sode_clpr_codi is null then
      if v_clpr_codi is not null then
        pp_muestra_clie(v_clpr_codi, :babmc.clpr_desc, :babmc.clpr_codi_alte, :babmc.clpr_clie_clas1_codi);
        :babmc.sode_clpr_codi := v_clpr_codi;
      end if;
      
      if v_sose_sucu_nume_item is not null then
        :babmc.sode_sucu_nume_item := v_sose_sucu_nume_item;
        pp_muestra_come_clpr_sub_cuen(:babmc.sode_clpr_codi, 
                                      :babmc.sode_sucu_nume_item, 
                                      :babmc.s_sucu_desc, 
                                      :babmc.s_sucu_tele);
      end if;
    end if;*/

  exception
    when no_data_found then
      pl_me('Vehiculo Inexistente.');
    when too_many_rows then
      pl_me('Existe mas de un vehiculo con el Identificador seleccionado. Favor Veifique!');
    when others then
      pl_me('Error al buscar detalles de vehiculo!. ' || sqlerrm);
  end pp_muestra_clie_vehi;

-----------------------------------------------validar

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
      pl_me('Error al consultar Cliente!. ' || sqlerrm);
  end pp_muestra_come_clie_prov;

-----------------------------------------------
  procedure pp_muestra_vehi(p_vehi_codi in number,
                            p_nume_pate out varchar2,
                            p_mave_desc out varchar2,
                            p_deta_mode out varchar2,
                            p_vehi_iden out varchar2) is
  begin
    select vehi_nume_pate, mave_desc, vehi_mode, vehi_iden
      into p_nume_pate, p_mave_desc, p_deta_mode, p_vehi_iden
      from come_vehi, come_marc_vehi
     where vehi_mave_codi = mave_codi
       and vehi_codi = p_vehi_codi;
  exception
    when no_data_found then
      pl_me('Vehiculo Inexistente');
    when others then
      pl_me('Error al consultar Vehiculo!. ' || sqlerrm);
  end pp_muestra_vehi;

-----------------------------------------------
  PROCEDURE pp_muestra_come_clpr_sub_cuen(p_clpr_codi      in number,
                                          p_sucu_nume_item in number,
                                          p_sucu_desc      out varchar2,
                                          p_sucu_tele      out varchar2) is
  BEGIN
    select sucu_desc, sucu_tele
      into p_sucu_desc, p_sucu_tele
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi
       and sucu_nume_item = p_sucu_nume_item;

  Exception
    when no_data_found then
      p_sucu_desc := null;
      p_sucu_tele := null;
      pl_me('Subcuenta Inexistente!');
    when others then
      pl_me('Error al consultar Subcuenta!. ' || sqlerrm);
  END pp_muestra_come_clpr_sub_cuen;

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
      pl_mm('No se podran realizar cambios a la Solicitud, porque fue generada desde la OT ' ||
            v_ortr_nume || ' por ' || v_ortr_desc);
      /*
        if get_item_property('bpie.aceptar', enabled) = 'TRUE' then
          set_item_property('bpie.aceptar', enabled, property_false);
        end if;
        if get_item_property('bpie.borrar', enabled) = 'TRUE' then
          set_item_property('bpie.borrar', enabled, property_false);
        end if;
      else
        if get_item_property('bpie.aceptar', enabled) = 'FALSE' then
          set_item_property('bpie.aceptar', enabled, property_true);
          set_item_property('bpie.aceptar', navigable, property_true);
        end if;
        if get_item_property('bpie.borrar', enabled) = 'FALSE' then
          set_item_property('bpie.borrar', enabled, property_true);
          set_item_property('bpie.borrar', navigable, property_true);
        end if; */
    end if;

  exception
    when no_data_found then
      null;
  end pp_veri_ot_sode;

-----------------------------------------------
  procedure pp_send_values is
    
  begin
    
    --setitem('', );
    /*
    setitem('P126_SODE_ESTA', babmc.sode_esta);
    setitem('P126_S_SODE_FECH_EMIS', babmc.sode_fech_emis);
    setitem('P126_SODE_CLPR_CODI', babmc.sode_clpr_codi);
    setitem('P126_SODE_VEHI_CODI', babmc.sode_vehi_codi);
    setitem('P126_SODE_SUCU_NUME_ITEM', babmc.sode_sucu_nume_item);
    setitem('P126_SODE_TIPO_MOTI', babmc.sode_tipo_moti);
    setitem('P126_SODE_MOTI', babmc.sode_moti);
    setitem('P126_SODE_USER_REGI', babmc.sode_user_regi);
    setitem('P126_SODE_FECH_REGI', babmc.sode_fech_regi);
    setitem('P126_SODE_USER_MODI', babmc.sode_user_modi);
    setitem('P126_SODE_FECH_MODI', babmc.sode_fech_modi);*/
    
    setitem('P132_SODE_ESTA', babmc.sode_esta);
    setitem('P132_S_SODE_FECH_EMIS', babmc.sode_fech_emis);
    setitem('P132_SODE_CLPR_CODI', babmc.sode_clpr_codi);
    setitem('P132_SODE_VEHI_CODI', babmc.sode_vehi_codi);
    setitem('P132_SODE_SUCU_NUME_ITEM', babmc.sode_sucu_nume_item);
    setitem('P132_SODE_TIPO_MOTI', babmc.sode_tipo_moti);
    setitem('P132_SODE_MOTI', babmc.sode_moti);
    setitem('P132_SODE_USER_REGI', babmc.sode_user_regi);
    setitem('P132_SODE_FECH_REGI', babmc.sode_fech_regi);
    setitem('P132_SODE_USER_MODI', babmc.sode_user_modi);
    setitem('P132_SODE_FECH_MODI', babmc.sode_fech_modi);
    
  end pp_send_values;
  
-----------------------------------------------
  procedure pp_ejecutar_consulta(i_sode_codi in number) is
    --v_sode_codi number;
  begin

    /*select sode_codi
      into v_sode_codi
      from come_soli_desi
     where sode_nume = i_sode_nume
       and nvl(sode_empr_codi, 1) = nvl(i_sode_empr_codi, 1)
       and nvl(sode_tipo_moti, 'O') = 'G';*/

    --set_block_property('babmc',default_where,' sode_codi = '||to_char(v_sode_codi));

    /*clear_block(no_validate);
    execute_query;    
    next_item;*/
    
    ----
    
    select sode_empr_codi,
           sode_codi,
           sode_nume,
           sode_fech_emis,
           sode_clpr_codi,
           sode_sucu_nume_item,
           sode_anex_codi,
           sode_deta_codi,
           sode_deta_nume_item,
           sode_vehi_codi,
           sode_tipo_moti,
           sode_moti,
           sode_user_regi,
           to_char(sode_fech_regi,'DD/MM/YYYY HH24:MI:SS'),
           sode_user_modi,
           to_char(sode_fech_modi,'DD/MM/YYYY HH24:MI:SS'),
           sode_base,
           sode_esta
      into babmc.sode_empr_codi,
           babmc.sode_codi,
           babmc.sode_nume,
           babmc.sode_fech_emis,
           babmc.sode_clpr_codi,
           babmc.sode_sucu_nume_item,
           babmc.sode_anex_codi,
           babmc.sode_deta_codi,
           babmc.sode_deta_nume_item,
           babmc.sode_vehi_codi,
           babmc.sode_tipo_moti,
           babmc.sode_moti,
           babmc.sode_user_regi,
           babmc.sode_fech_regi,
           babmc.sode_user_modi,
           babmc.sode_fech_modi,
           babmc.sode_base,
           babmc.sode_esta
      from come_soli_desi
     where sode_codi = i_sode_codi;
     
      babmc.w_indi_oper := 'U';

      if babmc.sode_empr_codi is null then
        babmc.sode_empr_codi := parameter.p_empr_codi;
      end if;

      /*
      if babmc.sode_empr_codi is not null then
        --pl_muestra_come_empr(babmc.sode_empr_codi, babmc.empr_desc);
        babmc.empr_colo := fp_devu_color(babmc.sode_empr_codi);
      end if;*/

      if babmc.sode_fech_emis is not null then
        babmc.s_sode_fech_emis := to_char(babmc.sode_fech_emis,'dd/mm/yyyy');
      end if;

      
      if babmc.sode_clpr_codi is not null then
        pp_muestra_come_clie_prov(babmc.sode_clpr_codi, babmc.clpr_desc, babmc.clpr_codi_alte);
      end if;
      

      /*
      if babmc.sode_vehi_codi is not null then
        pp_muestra_vehi(babmc.sode_vehi_codi, 
                        babmc.vehi_nume_pate, babmc.vehi_marc, 
                        babmc.vehi_mode     , babmc.vehi_iden);
      end if;
      */

      /*
      if babmc.sode_sucu_nume_item is not null then
        pp_muestra_come_clpr_sub_cuen(babmc.sode_clpr_codi, 
                                      babmc.sode_sucu_nume_item, 
                                      babmc.s_sucu_desc, 
                                      babmc.s_sucu_tele);
      end if;
      */

      if babmc.sode_tipo_moti is null then
        babmc.sode_tipo_moti := 'O';
      end if;
      
      --
      pp_send_values;
      --
      --pp_veri_ot_sode;
     ----
  
  exception
    when no_data_found then
      null;
    when others then
      pl_me('Error al consultar registro!. ' || sqlerrm);
        
  end pp_ejecutar_consulta;

-----------------------------------------------
  
-----------------------------------------------
  procedure pp_valida is

    v_count     number := 0;
    v_ortr_nume varchar2(200);
    v_cant      number := 0;

    cursor c_ortr is
      select o.ortr_nume
        from come_orde_trab o, come_vehi v
       where ortr_esta = 'P'
         and o.ortr_vehi_codi = v.vehi_codi
         and o.ortr_clpr_codi = babmc.sode_clpr_codi
         and (babmc.sode_sucu_nume_item is null or
             o.ortr_clpr_sucu_nume_item = babmc.sode_sucu_nume_item)
         and v.vehi_iden = babmc.vehi_iden;

  begin
    if babmc.sode_nume is null then
      pl_me('Debe ingresar Nro Solicitud de Desinstalacion.');
    end if;

    if babmc.s_sode_fech_emis is null then
      pl_me('Debe ingresar la fecha de emision de la Solicitud.');
    end if;
    
    if babmc.sode_clpr_codi is null then
      pl_me('Debe seleccionar un Cliente.');
    end if;
    
    if babmc.sode_vehi_codi is null then
      pl_me('Debe seleccionar un Vehiculo.');
    end if;
    
    if babmc.sode_moti is null then
      pl_me('Debe ingresar una Observacion.');
    end if;
    

    select count(*)
      into v_count
      from come_soli_desi
     where sode_vehi_codi = babmc.sode_vehi_codi
       and nvl(sode_esta, 'P') <> 'L'
       and sode_tipo_moti = 'G'; ---tipo Desinstalacion de Grua

    if v_count > 0 then
      pl_me('El vehiculo esta relacionado a una Solicitud de Desinstalacion de Grua Pendiente o Autorizada.');
    end if;

    for x in c_ortr loop
      v_ortr_nume := v_ortr_nume || x.ortr_nume || ' - ';
      v_cant      := v_cant + 1;
    
      if v_cant > 9 then
        exit;
      end if;
    end loop;

    if v_ortr_nume is not null then
      pl_me('No puede realizar la solicitud porque existen ' || v_ortr_nume ||
            ' OT en estado pendiente asignados al cliente.');
    end if;

  exception
    when no_data_found then
      null;
  end pp_valida;

-----------------------------------------------
  procedure pp_valida_secuencia is
    v_sode_nume number;
    v_count     number := 1;
    v_sode_codi number;
  begin
    v_sode_nume := babmc.sode_nume;

    while v_count <> 0 loop
      begin
        select sode_codi
          into v_sode_codi
          from come_soli_desi
         where sode_nume = v_sode_nume;
      
        v_count     := v_count + 1;
        v_sode_nume := v_sode_nume + 1;
      
      exception
        when no_data_found then
          v_count         := 0;
          babmc.sode_nume := v_sode_nume;
      end;
    end loop;
  end pp_valida_secuencia;

-----------------------------------------------
  procedure pp_genera_codigo is
  begin
    select nvl(max(sode_codi), 0) + 1
      into babmc.sode_codi
      from come_soli_desi;
  end pp_genera_codigo;

-----------------------------------------------
  procedure pp_valida_vehi(p_deta_iden in varchar2, p_vehi_codi out number) is

    v_vehi_codi      number;
    v_clpr_codi      number;
    v_count          number;
    v_deta_esta      varchar2(1);
    v_vehi_esta_vehi varchar2(1);
    v_deta_codi      number;
    v_deta_codi_grua number;

  begin

       select vehi_codi,
           vehi_clpr_codi,
           nvl(d.deta_esta, vehi_esta) deta_esta,
           vehi_esta_vehi,
           d.deta_codi,
           dh.deta_codi deta_codi_grua
      into v_vehi_codi,
           v_clpr_codi,
           v_deta_esta,
           v_vehi_esta_vehi,
           v_deta_codi,
           v_deta_codi_grua
      from come_marc_vehi,
           come_vehi,
           come_soli_serv_anex_deta d,
           come_soli_serv_anex_deta dh,
           come_soli_serv_anex_plan K
     where d.deta_vehi_codi = vehi_codi
       and vehi_mave_codi = mave_codi(+)
       and nvl(d.deta_esta, vehi_esta) in ('I', 'N')
       and nvl(vehi_esta_vehi, 'A') <> 'I'
       and nvl(vehi_indi_grua, 'N') = 'S'
       and nvl(d.deta_esta_plan, 'S') = 'S'
       and d.deta_codi = dh.deta_codi_anex_padr
       and nvl(dh.deta_esta_plan, 'N') = 'S'
       and (vehi_clpr_codi = babmc.sode_clpr_codi or
           babmc.sode_clpr_codi is null)
       and (vehi_clpr_sucu_nume_item = babmc.sode_sucu_nume_item or
           babmc.sode_sucu_nume_item is null)
       and nvl(d.deta_iden, vehi_iden) = p_deta_iden
       
       and k.anpl_deta_codi = dh.deta_codi
       and k.anpl_anex_codi = dh.deta_anex_codi
       and k.anpl_deta_esta_plan  ='S'
       and k.anpl_movi_codi is null
       and nvl(dh.deta_esta_plan, 'N') = 'S'
        group by vehi_codi,
           vehi_clpr_codi,
           nvl(d.deta_esta, vehi_esta) ,
           vehi_esta_vehi,
           d.deta_codi,
           dh.deta_codi ;
        

    begin
      select count(*)
        into v_count
        from come_soli_desi
       where sode_vehi_codi = v_vehi_codi
         and (sode_codi <> babmc.sode_codi or babmc.sode_codi is null)
         and sode_esta = 'P';
    
      if v_count > 0 then
        pl_me('El Vehiculo seleccionado ya esta relacionado a una Solicitud de Desinstalacion de Grua.');
      end if;
    end;

    if babmc.W_INDI_OPER = 'I' then
      if v_clpr_codi <> babmc.sode_clpr_codi then
        pl_me('El vehiculo no pertenece al Cliente seleccionado.');
      end if;
    
      if v_deta_esta not in ('I', 'N') then
        pl_me('El vehiculo debe estar Instalado!');
      end if;
    
      if v_vehi_esta_vehi = 'I' then
        pl_me('El vehiculo esta Inactivo.');
      end if;
    end if;

    p_vehi_codi          := v_vehi_codi;
    babmc.sode_deta_codi := v_deta_codi_grua;

  exception
    when no_data_found then
      pl_me('Vehiculo inexistente.');
  end pp_valida_vehi;

-----------------------------------------------
  procedure pp_generar_ot is
    cursor c_user is
      select us.user_login
        from come_admi_mens m, come_admi_mens_user u, segu_user us
       where m.adme_codi = u.meus_adme_codi
         and u.meus_user_codi = us.user_codi
         and m.adme_procedure = 'PA_GENE_MENS_SOLI_DESI';

    v_ortr_codi      number;
    v_ortr_nume      number;
    v_ortr_fech_emis date;
    v_ortr_desc      varchar2(100);
    v_clpr_desc      varchar2(100);
  begin
    if babmc.w_indi_oper = 'I' then
      v_clpr_desc := babmc.clpr_desc;
    
      if babmc.sode_esta = 'P' then
        for x in c_user loop
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
             ('Se ha generado una nueva solicitud de Desinstalacion con Nro. ' ||
             babmc.sode_nume || ' pare el cliente ' || v_clpr_desc ||
             ', con fecha de emision' || babmc.sode_fech_emis),
             x.user_login,
             user,
             sysdate,
             'N',
             'SD', --solicitud de desinstalacion
             babmc.sode_codi);
        end loop;
      
      else
        null; --en caso de que las aseguradoras autoricen automatico, aqui debera ir el proceso de autorizacion
      end if;
    end if;
  end pp_generar_ot;

-----------------------------------------------
  procedure pp_actualizar_registro( i_sode_clpr_codi in number,
                                    i_sode_sucu_nume_item in number,
                                    i_vehi_iden in varchar2,
                                    i_sode_nume in number,
                                    i_sode_moti in varchar2,
                                    i_s_sode_fech_emis in date,
                                    i_sode_vehi_codi in number,
                                    i_sode_codi in number,
                                    i_sode_empr_codi in number) is
    
  begin
    
    
    babmc.sode_clpr_codi      := i_sode_clpr_codi;
    babmc.sode_sucu_nume_item := i_sode_sucu_nume_item;
    babmc.vehi_iden           := i_vehi_iden;
    babmc.sode_nume           := i_sode_nume;
    babmc.sode_moti           := i_sode_moti;
    babmc.s_sode_fech_emis    := i_s_sode_fech_emis;
    babmc.sode_vehi_codi      := i_sode_vehi_codi;
    babmc.sode_codi           := i_sode_codi;
    babmc.sode_empr_codi      := i_sode_empr_codi;
    
    
    /*go_block('babmc');
    if (get_block_property('babmc', status)) = 'CHANGED' or
       (get_block_property('bvehi', status)) = 'CHANGED' then*/
    
      pp_valida;
      
      --obs: agregar validacion
      pp_veri_ot_sode;
    
      if babmc.sode_codi is null then
        pp_valida_secuencia;
        
        --PRE-INSERT
        babmc.sode_base      := parameter.p_codi_base;
        babmc.sode_user_regi := gen_user;
        --babmc.sode_fech_regi := to_date(to_char(sysdate,'DD/MM/YYYY HH24:MI:SS'), 'DD/MM/YYYY HH24:MI:SS');
        babmc.sode_fech_emis := sysdate;--babmc.sode_fech_regi;
        babmc.sode_tipo_moti := 'G';  --Tipo Grua
        pp_genera_codigo;
        babmc.sode_esta := 'P';
        babmc.W_INDI_OPER := 'I';
        
        pp_muestra_vehi(babmc.sode_vehi_codi, 
                        babmc.vehi_nume_pate, babmc.vehi_marc, 
                        babmc.vehi_mode     , babmc.vehi_iden);
        pp_valida_vehi(babmc.vehi_iden, babmc.sode_vehi_codi);
        --
        
        --INSERT
        insert into come_soli_desi
          (sode_codi, sode_nume, sode_empr_codi, sode_anex_codi, sode_deta_nume_item, sode_fech_emis, sode_user_regi, sode_fech_regi, sode_user_modi, sode_fech_modi, sode_base, sode_clpr_codi, sode_sucu_nume_item, sode_esta, sode_vehi_codi, sode_moti, sode_tipo_moti, sode_deta_codi)
        values
          (babmc.sode_codi, babmc.sode_nume, babmc.sode_empr_codi, babmc.sode_anex_codi, babmc.sode_deta_nume_item, babmc.sode_fech_emis, babmc.sode_user_regi, babmc.sode_fech_emis, babmc.sode_user_modi, babmc.sode_fech_modi, babmc.sode_base, babmc.sode_clpr_codi, babmc.sode_sucu_nume_item, babmc.sode_esta, babmc.sode_vehi_codi, babmc.sode_moti, babmc.sode_tipo_moti, babmc.sode_deta_codi);
        --
        
        --POST-INSERT
        pp_generar_ot;
        --
        apex_application.g_print_success_message:= 'Registro Insertado. Nro: '|| babmc.sode_nume||' !';
      else
        pl_me('El registro no puede ser Modificado');
        
      end if;
    
      /*commit_form;
    
      if not form_success then
        clear_block(no_validate);
        message('Registro no actualizado.');
      else
        message('Registro actualizado.');
        clear_block(no_validate);
      end if;
      if form_failure then
        raise form_trigger_failure;
      end if;
    else
      pl_mostrar_mensaje('No Existen Camios que guardar');
    end if;*/
    
  end pp_actualizar_registro;

-----------------------------------------------
  procedure pp_validar_borrado is
    v_count number(6);
  begin

    select count(*)
      into v_count
      from come_orde_trab
     where ortr_sode_codi = babmc.sode_codi;

    if v_count > 0 then
      pl_me('Existen ' || v_count ||
            ' ordenes de trabajo que tienen asignados esta solicitud de desinstalacion. ' ||
            'Primero se deben borrar o asignar a otro');
    end if;

    if babmc.sode_esta <> 'P' then
      pl_me('La solicitud de desinstalacion debe estar Pendiente para poder eliminar.');
    end if;

  end pp_validar_borrado;

-----------------------------------------------
  procedure pp_borrar_registro(i_sode_codi in number,
                               i_sode_esta in varchar2) is
                               
     v_message   varchar2(70) := '?Realmente desea Borrar el registro?';
  
  begin
    
     if i_sode_codi is null then
        pl_me('No se ha seleccionado ningun registro! ');
     end if;
     
     if i_sode_esta is null then
        pl_me('El estado del registro esta vacio! ');
     end if;
     
     babmc.sode_codi := i_sode_codi;
     babmc.sode_esta := i_sode_esta;

     --
     pp_veri_ot_sode;
      
     pp_validar_borrado;
     
     --eliminar registro
     delete come_soli_desi
     where sode_codi = babmc.sode_codi;
     
     apex_application.g_print_success_message:= 'Registro Eliminado correctamente!';
     
     --
     
     

    /*
    if :babmc.sode_codi is null then
      go_block('babmc');
    else
      
      set_alert_button_property('AL_CONFIRMAR',alert_button3,label, null);
      if fl_confirmar_reg_borra(v_message) = 'CONFIRMAR' then
        go_block('babmc');
        delete_record;
        
        commit_form;
        if not form_success then
          clear_block(no_validate);
          message('Registro no borrado.');
        else
          message('Registro borrado.');
          clear_block(no_validate);
        end if;
        if form_failure then
          raise form_trigger_failure;
        end if;
      end if;
    end if;
    */
  
  end pp_borrar_registro;


-----------------------------------------------
    
  
  
end I020286G_A;
