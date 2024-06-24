
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010288" is

  type r_parameter is record(

    p_codi_base           number := pack_repl.fa_devu_codi_base,
    p_codi_timo_reem      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_reem')),
    p_indi_most_mens_sali varchar2(60) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    p_codi_tipo_empl_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr')),
    p_orden_codi          varchar2(60) := 'desc',
    p_orden_desc          varchar2(60) := 'asc',
    p_empr_codi           number := v('AI_EMPR_CODI'),
    p_query               varchar2(60) := 'N');

  parameter r_parameter;

  procedure pp_actualizar_registro(i_ind                 in varchar2,
                                   i_tare_empr_codi      in varchar2,
                                   i_tare_codi           in varchar2,
                                   i_tare_codi_alte      in varchar2,
                                   i_tare_empl_codi      in varchar2,
                                   i_tare_reci_desd      in varchar2,
                                   i_tare_reci_hast      in varchar2,
                                   i_tare_cant           in varchar2,
                                   i_tare_tico_codi      in varchar2,
                                   i_tare_ulti_nume      in varchar2,
                                   i_tare_indi_talo_manu in varchar2,
                                   i_tare_esta           in varchar2,
                                   i_tare_base           in varchar2,
                                   i_tare_user_regi      in varchar2,
                                   i_tare_fech_regi      in varchar2) is

    v_tare_cant      varchar2(60);
    v_tare_base      varchar2(60);
    v_tare_user_regi varchar2(60);
    v_tare_fech_regi varchar2(60);
    v_tare_nume_esta varchar2(60);
    v_tare_nume_expe varchar2(60);
    x_tare_codi      number;
    x_tare_codi_alte number;

  begin

    if i_tare_empl_codi is null then
      raise_application_error(-20001,
                              'Debe especificar un cobrador para entregar el talonario de recibo.');
    end if;
    if i_tare_reci_desd is null then
      raise_application_error(-20001,
                              'Debe ingresar el primer numero de comprobante del talonario');
    end if;
    if i_tare_reci_hast is null then
      raise_application_error(-20001,
                              'Debe ingresar el ultimo numero de Comprobante del talonario');
    end if;
    if i_tare_ulti_nume is null then
      raise_application_error(-20001,
                              'Debe ingresar el Ultimo numero de recibo ingresado');
    end if;

    v_tare_cant := null; -- :babmc.w_tare_cant;
    v_tare_base := parameter.p_codi_base;

    -------no existen estos ampos
    v_tare_nume_esta := null; -- :babmc.s_tare_nume_esta ;
    v_tare_nume_expe := null; --:babmc.s_tare_nume_expe;

    I010288.pp_veri_entr_talo(i_tare_reci_desd => i_tare_reci_desd,
                              i_tare_reci_hast => i_tare_reci_hast,
                              i_tare_tico_codi => i_tare_tico_codi,
                              i_tare_empr_codi => i_tare_empr_codi,
                              i_tare_codi      => i_tare_codi);

    I010288.pp_validar_ulti_nume(i_tare_ulti_nume => i_tare_ulti_nume,
                                 i_tare_reci_desd => i_tare_reci_desd,
                                 i_tare_reci_hast => i_tare_reci_hast);

    if i_ind = 'I' then
      select nvl(max(tare_codi),0)+1, nvl(max(tare_codi_alte),0)+1
	    into x_tare_codi, x_tare_codi_alte
	    from come_talo_reci;
      insert into come_talo_reci
        (tare_empr_codi,
         tare_codi,
         tare_codi_alte,
         tare_empl_codi,
         tare_reci_desd,
         tare_reci_hast,
         tare_cant,
         tare_tico_codi,
         tare_ulti_nume,
         tare_indi_talo_manu,
         tare_esta,
         tare_base,
         tare_user_regi,
         tare_fech_regi)
      values
        (i_tare_empr_codi,
         x_tare_codi,
         x_tare_codi_alte,
         i_tare_empl_codi,
         i_tare_reci_desd,
         i_tare_reci_hast,
         i_tare_cant, --
         i_tare_tico_codi,
         i_tare_ulti_nume,
         i_tare_indi_talo_manu,
         i_tare_esta,
         v_tare_base,
         gen_user, --
         sysdate); --

    elsif i_ind = 'U' then

      update come_talo_reci
         set tare_empr_codi      = i_tare_empr_codi,
             tare_codi_alte      = i_tare_codi_alte,
             tare_empl_codi      = i_tare_empl_codi,
             tare_reci_desd      = i_tare_reci_desd,
             tare_reci_hast      = i_tare_reci_hast,
             tare_cant           = i_tare_cant,
             tare_tico_codi      = i_tare_tico_codi,
             tare_ulti_nume      = i_tare_ulti_nume,
             tare_indi_talo_manu = i_tare_indi_talo_manu,
             tare_esta           = i_tare_esta,
             tare_base           = v_tare_base,
             tare_user_modi      = gen_user,
             tare_fech_modi      = sysdate
       where tare_codi = i_tare_codi;

    end if;

  end pp_actualizar_registro;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_veri_entr_talo(i_tare_reci_desd in varchar,
                              i_tare_reci_hast in varchar,
                              i_tare_tico_codi in varchar,
                              i_tare_empr_codi in varchar,
                              i_tare_codi      in varchar) is
    v_count number;
  begin

    select count(*)
      into v_count
      from come_talo_reci a
     where i_tare_reci_desd between a.tare_reci_desd and a.tare_reci_hast
       and a.tare_tico_codi = i_tare_tico_codi
       and a.tare_empr_codi = i_tare_empr_codi
       and a.tare_codi <> nvl(i_tare_codi, -1);
    if v_count > 0 then
      raise_application_error(-20001,
                              'El talonario con este rango ya fue previamente entregado a un cobrador.');
    end if;

    select count(*)
      into v_count
      from come_talo_reci a
     where i_tare_reci_hast between a.tare_reci_desd and a.tare_reci_hast
       and a.tare_tico_codi = i_tare_tico_codi
       and a.tare_empr_codi = i_tare_empr_codi
       and a.tare_codi <> nvl(i_tare_codi, -1);
    if v_count > 0 then
      raise_application_error(-20001,
                              'El talonario con este rango ya fue previamente entregado a un cobrador.');
    end if;
  end pp_veri_entr_talo;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_validar_ulti_nume(i_tare_ulti_nume number,
                                 i_tare_reci_desd number,
                                 i_tare_reci_hast number) is
  begin
    if i_tare_ulti_nume not between (i_tare_reci_desd - 1) and
       i_tare_reci_hast then
      raise_application_error(-20001,
                              'El ultimo numero no corresponde al talonario');
    end if;
  end pp_validar_ulti_nume;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_borrar_registro(i_tare_codi in number) is

  begin

    I010288.pp_validar_borrado(i_tare_codi);

    if i_tare_codi is null then
      raise_application_error(-20001,
                              'Primero debe seleccionar un registro');
    else
      delete come_talo_reci where tare_codi = i_tare_codi;
    end if;

  end pp_borrar_registro;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_validar_borrado(i_tare_codi in number) is
    v_count     number;
    v_reci_desd number;
    v_reci_hast number;
  begin

    begin
      select tare_reci_desd, tare_reci_hast
        into v_reci_desd, v_reci_hast
        from come_talo_reci
       where tare_codi = i_tare_codi;
    exception
      when no_data_found then
        v_reci_desd := 0;
        v_reci_hast := 0;
    end;

    select count(*)
      into v_count
      from come_movi a
     where a.movi_timo_codi = 13
       and a.movi_nume between v_reci_desd and v_reci_hast;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'recibos emitidos de este talonario, no puede ser eliminado');
    end if;

  end pp_validar_borrado;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_muestra_come_empl(i_tare_empl_codi in number,
                                 i_tare_empr_codi in number,
                                 o_tare_tico_codi out number,
                                 o_tico_codi_alte out number) is
    v_tico_desc varchar2(60);
  begin

    if nvl(parameter.p_query, 'N') = 'N' then
      pp_veri_salt_pend(i_tare_empl_codi);
    end if;

    ---- por ahora el programa solo funcionara para recibo emitido
    begin
      select timo_tico_codi, tico_codi_alte
        into o_tare_tico_codi, o_tico_codi_alte
        from come_tipo_movi, come_tipo_comp
       where timo_codi_alte = parameter.p_codi_timo_reem
         and timo_empr_codi = i_tare_empr_codi
         and timo_tico_codi = tico_codi_alte;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'El tipo de movimiento recibo emitido no esta enlazado con el tipo de comprobante recibo.');
    end;

    pp_muestra_come_tipo_comp(o_tico_codi_alte,
                              i_tare_empr_codi,
                              o_tare_tico_codi,
                              v_tico_desc);

  end pp_muestra_come_empl;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_veri_salt_pend(p_empl_codi in number) is
    cursor c_salt is
      select s.resa_nume_comp
        from come_reci_salt_auto s, come_talo_reci t
       where s.resa_tare_codi = t.tare_codi
         and t.tare_empl_codi = p_empl_codi
         and s.resa_fech_rend < trunc(sysdate)
         and s.resa_esta = 'A'
       order by 1;

    v_mens varchar2(2000);
  begin
    v_mens := null;
    for k in c_salt loop
      if v_mens is null then
        v_mens := k.resa_nume_comp;
      else
        v_mens := v_mens || ', ' || k.resa_nume_comp;
      end if;
    end loop;

    if v_mens is not null then
      raise_application_error(-20001,
                              'El cobrador posee recibos con fecha de rendicion vencidas ' ||
                              v_mens);
    end if;
  end pp_veri_salt_pend;

----------------------------------------------------------------------------------------------------------------------------------------

  procedure pp_muestra_come_tipo_comp(i_tico_codi_alte in varchar2,
                                      i_tico_empr_codi in number,
                                      o_tico_codi      out number,
                                      o_tico_desc      out varchar2) is
  begin
    select t.tico_codi, t.tico_desc
      into o_tico_codi, o_tico_desc
      from come_tipo_comp t
     where t.tico_codi_alte = i_tico_codi_alte
       and t.tico_empr_codi = i_tico_empr_codi;

  exception
    when no_data_found then

      raise_application_error(-20001, 'Tipo de Comprobante inexistente!');

  end pp_muestra_come_tipo_comp;

end I010288;
