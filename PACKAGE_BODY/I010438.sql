
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010438" is

  -- Private type declarations
  type r_parameter is record(
     p_empr_codi number,
     collection_name1 varchar2(30) :='COLL_BDISP',
     collection_name2 varchar2(30) :='COLL_BSELE',
     collection_name3 varchar2(30) :='COLL_BDET'
  );
  parameter r_parameter;

  type r_babmc is record(
     plsu_codi                 rrhh_plan_suel.plsu_codi%type,
      plsu_desc                rrhh_plan_suel.plsu_desc%type,
      plsu_empr_codi           rrhh_plan_suel.plsu_empr_codi%type,
      plsu_codi_alte           rrhh_plan_suel.plsu_codi_alte%type,
      plsu_gest_conc_codi      rrhh_plan_suel.plsu_gest_conc_codi%type,
      plsu_conc_codi           rrhh_plan_suel.plsu_conc_codi%type,
      plsu_indi_desc_rete      rrhh_plan_suel.plsu_indi_desc_rete%type,
      plsu_cuco_codi_suel_apag rrhh_plan_suel.plsu_cuco_codi_suel_apag%type,
      plsu_cuco_codi_suel_jorn rrhh_plan_suel.plsu_cuco_codi_suel_jorn%type,
      plsu_cuco_codi_adel      rrhh_plan_suel.plsu_cuco_codi_adel%type,
      plsu_cuco_codi_boni_fami rrhh_plan_suel.plsu_cuco_codi_boni_fami%type,
      plsu_cuco_codi_carg_soci rrhh_plan_suel.plsu_cuco_codi_carg_soci%type,
      plsu_cuco_codi_apor_apag rrhh_plan_suel.plsu_cuco_codi_apor_apag%type,
      plsu_cuco_codi_vaca      rrhh_plan_suel.plsu_cuco_codi_vaca%type,
      plsu_cuco_codi_agui      rrhh_plan_suel.plsu_cuco_codi_agui%type,
      plsu_cuco_codi_hora_extr rrhh_plan_suel.plsu_cuco_codi_hora_extr%type,
      plsu_cuco_codi_pi        rrhh_plan_suel.plsu_cuco_codi_pi%type,
      plsu_cuco_codi_pe        rrhh_plan_suel.plsu_cuco_codi_pe%type,
      plsu_cuco_codi_viat      rrhh_plan_suel.plsu_cuco_codi_viat%type,
      plsu_cuco_codi_comi      rrhh_plan_suel.plsu_cuco_codi_comi%type,
      --
      p_indi                   varchar2(2),
      p_roles                  varchar2(3000)

  );
  babmc r_babmc;

  cursor cur_bdet is
    select det.seq_id nro,
         c001 plco_codi,
         c002 plco_plsu_codi,
         c003 plco_conc_codi,
         c004 conc_desc,
         c005 conc_codi_alte,
         c006 conc_indi_auto,
         c007 indicador
   from apex_collections det
    where det.collection_name= 'COLL_BDET';


-----------------------------------------------
  procedure pp_muestra_come_cuen_cont(p_codi in number) is

    v_indi_impu varchar2(1);

  begin

    if p_codi is not null then

      select cuco_indi_impu
        into v_indi_impu
        from come_cuen_cont
       where cuco_codi = p_codi;

      if nvl(v_indi_impu, 'N') <> 'S' then
        raise_application_error(-20010, 'Debe ingresar solamente las cuentas contables imputables !!!');
      end if;

    end if;

  Exception
    when no_data_found then
      raise_application_error(-20010, 'Cuenta Contable inexistente!');
    when others then
      raise_application_error(-20010, 'Error al validar Cuenta Contable' || sqlerrm);

  end pp_muestra_come_cuen_cont;

-----------------------------------------------
  procedure pp_muestra_conc_alte(p_conc_codi in number,
                                 p_empr      in number) is
    v_cant number;
  begin

    parameter.p_empr_codi := p_empr;

    select count(*)
      into v_cant
      from come_conc
     where rtrim(ltrim(conc_codi)) = rtrim(ltrim(p_conc_codi))
       and conc_empr_codi = parameter.p_empr_codi;

    if v_cant <= 0 then
      raise_application_error(-20010, 'Concepto Inexistente.!');
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Concepto Inexistente.!');
    when others then
      raise_application_error(-20010, 'Error al validar Concepto de Gesti¿n.! ' || sqlerrm);
  end pp_muestra_conc_alte;

-----------------------------------------------
  procedure pp_genera_codi_alte is

  begin

    select nvl(max(to_number(plsu_codi_alte)), 0) + 1
      into babmc.plsu_codi_alte
      from rrhh_plan_suel
     where plsu_empr_codi = parameter.p_empr_codi;

  exception
    when others then
      null;

  end pp_genera_codi_alte;

-----------------------------------------------
  procedure pp_ejecutar_consulta is
    v_codi number;
  begin

    select plsu_codi
      into v_codi
      from rrhh_plan_suel
     where rtrim(ltrim(plsu_codi_alte)) = rtrim(ltrim(babmc.plsu_codi_alte))
       and plsu_empr_codi = parameter.p_empr_codi;

    select plsu_codi,
           plsu_desc,
           plsu_empr_codi,
           plsu_codi_alte,
           plsu_gest_conc_codi,
           plsu_conc_codi,
           plsu_indi_desc_rete,
           plsu_cuco_codi_suel_apag,
           plsu_cuco_codi_suel_jorn,
           plsu_cuco_codi_adel,
           plsu_cuco_codi_boni_fami,
           plsu_cuco_codi_carg_soci,
           plsu_cuco_codi_apor_apag,
           plsu_cuco_codi_vaca,
           plsu_cuco_codi_agui,
           plsu_cuco_codi_hora_extr,
           plsu_cuco_codi_pi,
           plsu_cuco_codi_pe,
           plsu_cuco_codi_viat,
           plsu_cuco_codi_comi
      into babmc.plsu_codi,
           babmc.plsu_desc,
           babmc.plsu_empr_codi,
           babmc.plsu_codi_alte,
           babmc.plsu_gest_conc_codi,
           babmc.plsu_conc_codi,
           babmc.plsu_indi_desc_rete,
           babmc.plsu_cuco_codi_suel_apag,
           babmc.plsu_cuco_codi_suel_jorn,
           babmc.plsu_cuco_codi_adel,
           babmc.plsu_cuco_codi_boni_fami,
           babmc.plsu_cuco_codi_carg_soci,
           babmc.plsu_cuco_codi_apor_apag,
           babmc.plsu_cuco_codi_vaca,
           babmc.plsu_cuco_codi_agui,
           babmc.plsu_cuco_codi_hora_extr,
           babmc.plsu_cuco_codi_pi,
           babmc.plsu_cuco_codi_pe,
           babmc.plsu_cuco_codi_viat,
           babmc.plsu_cuco_codi_comi
      from rrhh_plan_suel
     where plsu_empr_codi = parameter.p_empr_codi
     and plsu_codi = v_codi;


    /*if get_item_property('babmc.gest_conc_codi_alte', enabled) = 'FALSE' then
    set_item_property('babmc.gest_conc_codi_alte', enabled, property_true);
    set_item_property('babmc.gest_conc_codi_alte', updateable, property_true);
    set_item_property('babmc.gest_conc_codi_alte', navigable, property_true);
    end if;*/

  exception
    when no_data_found then
      raise_application_error(-20010,'Plantilla Inexistente.');

  end pp_ejecutar_consulta;

-----------------------------------------------
  procedure pp_muestra_conc(p_codi      in number,
                            p_desc      out varchar2,
                            p_codi_alte out number) IS
    --v_esta varchar2(1);
  begin
    select conc_Desc, conc_Codi_alte
      into p_desc, p_codi_alte
      from rrhh_conc
     where conc_codi = p_codi;

  exception
    when no_data_found then
      p_desc      := null;
      p_codi_alte := null;
      raise_application_error(-20010,'Concepto Inexistente.!');
    when others then
      raise_application_error(-20010,'Error al buscar Concepto.! ' || sqlerrm);
  end pp_muestra_conc;

-----------------------------------------------
  procedure pp_cargar_bsele is

    cursor cur_bsele(i_plsu_codi in number) is
    select plde_plsu_codi, plde_conc_codi, plde_orden
     from rrhh_plan_suel_deta
    where plde_plsu_codi = i_plsu_codi;

    conc_desc varchar2(100);
    conc_codi_alte number;

  begin

    if apex_collection.collection_exists(p_collection_name => parameter.collection_name2) then
       apex_collection.truncate_collection (parameter.collection_name2);
    else
      apex_collection.create_collection(parameter.collection_name2);
    end if;

    for bsele in cur_bsele(babmc.plsu_codi) loop

      pp_muestra_conc(bsele.plde_conc_codi, conc_desc, conc_codi_alte);

      apex_collection.add_member(p_collection_name => parameter.collection_name2,
                                 p_c001            => bsele.plde_plsu_codi,
                                 p_c002            => bsele.plde_conc_codi,
                                 p_c003            => bsele.plde_orden,
                                 p_c004            => conc_desc,
                                 p_c005            => conc_codi_alte
                                );
    end loop;

  end pp_cargar_bsele;

-----------------------------------------------
  procedure pp_muestra_rrhh_conc(p_conc_codi      in number,
                                 p_conc_desc      out varchar2,
                                 p_conc_codi_alte out number,
                                 p_conc_indi_auto out varchar2) is

  begin
    select conc_desc, conc_codi_alte, conc_indi_auto
      into p_conc_desc, p_conc_codi_alte, p_conc_indi_auto
      from rrhh_conc
     where conc_codi = p_conc_codi;

  Exception
    when no_data_found then
      p_conc_desc      := null;
      p_conc_codi_alte := null;
      raise_application_error(-20010, 'Concepto Inexistente.');
    when others then
      raise_application_error(-20010, 'Error al buscar Concepto.! ' || sqlerrm);
  end pp_muestra_rrhh_conc;

-----------------------------------------------
  procedure pp_cargar_bdet is

    cursor cur_bdet(i_plco_codi in number) is
    select plco_codi, plco_plsu_codi, plco_conc_codi
     from rrhh_plan_suel_conc_deta
    where plco_plsu_codi = i_plco_codi;

    v_conc_desc      varchar2(30);
    v_conc_codi_alte number;
    v_conc_indi_auto varchar2(30);

  begin

    if apex_collection.collection_exists(p_collection_name => parameter.collection_name3) then
       apex_collection.truncate_collection (parameter.collection_name3);
    else
      apex_collection.create_collection(parameter.collection_name3);
    end if;

    for bdet in cur_bdet(babmc.plsu_codi) loop

      pp_muestra_rrhh_conc(bdet.plco_conc_codi, v_conc_desc, v_conc_codi_alte, v_conc_indi_auto);

      apex_collection.add_member(p_collection_name => parameter.collection_name3,
                                 p_c001            => bdet.plco_codi,
                                 p_c002            => bdet.plco_plsu_codi,
                                 p_c003            => bdet.plco_conc_codi,
                                 p_c004            => v_conc_desc,
                                 p_c005            => v_conc_codi_alte,
                                 p_c006            => v_conc_indi_auto,
                                 p_c007            => 'T'
                                );
    end loop;

  end pp_cargar_bdet;

-----------------------------------------------
  procedure pp_send_values is

  begin

    --raise_application_error(-20010, 'send value');
    setitem('P71_PLSU_CODI', babmc.plsu_codi);
    setitem('P71_PLSU_DESC',babmc.plsu_desc);
    setitem('P71_PLSU_INDI_DESC_RETE',babmc.plsu_indi_desc_rete);
    setitem('P71_PLSU_GEST_CONC_CODI',babmc.plsu_gest_conc_codi);
    setitem('P71_PLSU_CUCO_CODI_SUEL_APAG', babmc.plsu_cuco_codi_suel_apag);
    setitem('P71_PLSU_CUCO_CODI_SUEL_JORN', babmc.plsu_cuco_codi_suel_jorn);
    setitem('P71_PLSU_CUCO_CODI_ADEL', babmc.plsu_cuco_codi_adel);
    setitem('P71_PLSU_CUCO_CODI_BONI_FAMI', babmc.plsu_cuco_codi_boni_fami);
    setitem('P71_PLSU_CUCO_CODI_CARG_SOCI', babmc.plsu_cuco_codi_carg_soci);
    setitem('P71_PLSU_CUCO_CODI_APOR_APAG', babmc.plsu_cuco_codi_apor_apag);
    setitem('P71_PLSU_CUCO_CODI_VACA', babmc.plsu_cuco_codi_vaca);
    setitem('P71_PLSU_CUCO_CODI_AGUI', babmc.plsu_cuco_codi_agui);
    setitem('P71_PLSU_CUCO_CODI_HORA_EXTR', babmc.plsu_cuco_codi_hora_extr);
    setitem('P71_PLSU_CUCO_CODI_PI', babmc.plsu_cuco_codi_pi);
    setitem('P71_PLSU_CUCO_CODI_PE', babmc.plsu_cuco_codi_pe);
    setitem('P71_PLSU_CUCO_CODI_VIAT', babmc.plsu_cuco_codi_viat);
    setitem('P71_PLSU_CUCO_CODI_COMI', babmc.plsu_cuco_codi_comi);
    setitem('P71_PLSU_EMPR_CODI', babmc.plsu_empr_codi);
    setitem('P71_INDI', babmc.p_indi);

  end pp_send_values;

-----------------------------------------------
  procedure pp_validar_codigo(plsu_codi_alte in number,
                              empr_codi      in number) is

  begin

    babmc.plsu_codi_alte  := plsu_codi_alte;
    parameter.p_empr_codi := empr_codi;

    if babmc.plsu_codi_alte is null then

      raise_application_error(-20010, 'No se puede consultar el registro. Codigo nulo');

      --pp_genera_codi_alte;

    else
      pp_ejecutar_consulta;
      pp_cargar_bsele;
      pp_cargar_bdet;

      babmc.p_indi :='U';
      pp_send_values;

    end if;

  end pp_validar_codigo;

-----------------------------------------------
  procedure pp_muestra_rrhh_conc_alte (p_conc_codi_alte   in varchar2,
                                       p_empr_codi        in number,
                                       p_conc_desc        out varchar2,
                                       p_conc_codi        out number,
                                       p_conc_indi_auto   out varchar2
                                       ) is

  begin

    select conc_desc, conc_codi, conc_indi_auto
    into   p_conc_desc, p_conc_codi, p_conc_indi_auto
    from   rrhh_conc
    where  rtrim(ltrim(conc_codi_alte)) = rtrim(ltrim(p_conc_codi_alte))
      and conc_empr_codi = p_empr_codi;

  Exception
    when no_data_found then
       p_conc_desc := null;
       p_conc_codi := null;
       raise_application_error(-20010,'Concepto Inexistente.');
    when others then
       raise_application_error(-20010, 'Error al buscar Concepto.! ' || sqlerrm);
  end pp_muestra_rrhh_conc_alte;

-----------------------------------------------
  procedure pp_cargar_coll_bdet(i_plco_conc_codi in number,
                                i_conc_desc      in varchar2,
                                i_conc_codi_alte in number,
                                i_conc_indi_auto in varchar2) is

  begin

    if i_conc_codi_alte is null then
      raise_application_error(-20010, 'El Concepto no puede ser nulo!');
    end if;

    apex_collection.add_member(p_collection_name => parameter.collection_name3,
                               --p_c001            => bdet.plco_codi, --codigo generado
                               --p_c002            => bdet.plco_plsu_codi, --codigo_del registro
                               p_c003 => i_plco_conc_codi,
                               p_c004 => i_conc_desc,
                               p_c005 => i_conc_codi_alte,
                               p_c006 => i_conc_indi_auto,
                               p_c007 => 'I');

  end pp_cargar_coll_bdet;

-----------------------------------------------
  procedure pp_editar_coll_bdet(i_plco_conc_codi in number,
                                i_conc_desc      in varchar2,
                                i_conc_codi_alte in number,
                                i_conc_indi_auto in varchar2,
                                i_indi           in varchar2,
                                i_plco_codi      in number,
                                i_plco_plsu_codi in number,
                                i_seq            in number) is

  v_indi varchar2(2);

  begin

    if i_conc_codi_alte is null then
      raise_application_error(-20010, 'El Concepto no puede ser nulo!');
    end if;

    select c007 indicador
     into v_indi
     from apex_collections det
      where det.collection_name= 'COLL_BDET'
      and det.seq_id = i_seq;

    if i_indi = 'U' then
      if v_indi = 'T' then
        v_indi := 'U';
      end if;

      apex_collection.update_member(p_collection_name => parameter.collection_name3,
                                  p_seq             => i_seq,
                                  p_c001            => i_plco_codi,
                                  p_c002            => i_plco_plsu_codi,
                                  p_c003            => i_plco_conc_codi,
                                  p_c004            => i_conc_desc,
                                  p_c005            => i_conc_codi_alte,
                                  p_c006            => i_conc_indi_auto,
                                  p_c007            => v_indi);

    else

      if v_indi = 'I' then
        apex_collection.delete_member(p_collection_name => parameter.collection_name3,
                                      p_seq             => i_seq);
      else

        apex_collection.update_member(p_collection_name => parameter.collection_name3,
                                  p_seq             => i_seq,
                                  p_c001            => i_plco_codi,
                                  p_c002            => i_plco_plsu_codi,
                                  p_c003            => i_plco_conc_codi,
                                  p_c004            => i_conc_desc,
                                  p_c005            => i_conc_codi_alte,
                                  p_c006            => i_conc_indi_auto,
                                  p_c007            => 'D');
      end if;

    end if;



  end pp_editar_coll_bdet;

-----------------------------------------------
  procedure pp_valida is

    --v_indi_veri_conc varchar2(1) := 'N';

  begin

    if babmc.p_indi <> 'I' then
      if babmc.plsu_codi_alte is null then
        raise_application_error(-20010, 'Debe ingresar el c¿digo');
      end if;
    end if;


    /*if babmc.plsu_empr_codi is null then
      raise_application_error(-20010, 'Debe ingresar el c¿digo de Empresa.');
    end if;*/

    if babmc.plsu_desc is null then
      raise_application_error(-20010, 'Debe ingresar la descripci¿n');
    end if;

  end pp_valida;

-----------------------------------------------
  procedure pp_generar_codigo is
  begin
    select nvl(max(plsu_codi), 0) + 1
      into babmc.plsu_codi
      from rrhh_plan_suel;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Generaci¿n de c¿digo incorrecta');
    when too_many_rows then
      raise_application_error(-20010, 'TOO_MANY_ROWS llame a su administrador');
    when others then
      raise_application_error(-20010, 'Error en la generacion de codigo.! ' ||sqlerrm);

  end pp_generar_codigo;

-----------------------------------------------
  procedure pp_cargar_variables is

   begin

      --raise_application_error(-20010, 'babmc.p_roles: ' ||babmc.p_roles);

      babmc.plsu_codi                := V('P71_PLSU_CODI');
      babmc.plsu_desc                := V('P71_PLSU_DESC');
      babmc.plsu_empr_codi           := V('P71_PLSU_EMPR_CODI');
      babmc.plsu_codi_alte           := V('P71_PLSU_CODI_ALTE');
      babmc.plsu_gest_conc_codi      := V('P71_PLSU_GEST_CONC_CODI');
      babmc.plsu_indi_desc_rete      := V('P71_PLSU_INDI_DESC_RETE');
      babmc.plsu_cuco_codi_suel_apag := V('P71_PLSU_CUCO_CODI_SUEL_APAG');
      babmc.plsu_cuco_codi_suel_jorn := V('P71_PLSU_CUCO_CODI_SUEL_JORN');
      babmc.plsu_cuco_codi_adel      := V('P71_PLSU_CUCO_CODI_ADEL');
      babmc.plsu_cuco_codi_boni_fami := V('P71_PLSU_CUCO_CODI_BONI_FAMI');
      babmc.plsu_cuco_codi_carg_soci := V('P71_PLSU_CUCO_CODI_CARG_SOCI');
      babmc.plsu_cuco_codi_apor_apag := V('P71_PLSU_CUCO_CODI_APOR_APAG');
      babmc.plsu_cuco_codi_vaca      := V('P71_PLSU_CUCO_CODI_VACA');
      babmc.plsu_cuco_codi_agui      := V('P71_PLSU_CUCO_CODI_AGUI');
      babmc.plsu_cuco_codi_hora_extr := V('P71_PLSU_CUCO_CODI_HORA_EXTR');
      babmc.plsu_cuco_codi_pi        := V('P71_PLSU_CUCO_CODI_PI');
      babmc.plsu_cuco_codi_pe        := V('P71_PLSU_CUCO_CODI_PE');
      babmc.plsu_cuco_codi_viat      := V('P71_PLSU_CUCO_CODI_VIAT');
      babmc.plsu_cuco_codi_comi      := V('P71_PLSU_CUCO_CODI_COMI');
      babmc.p_indi                   := V('P71_INDI');
      babmc.p_roles                  := V('P71_ASIGNAR');

      parameter.p_empr_codi          := V('AI_EMPR_CODI');

   end pp_cargar_variables;

-----------------------------------------------
   procedure pp_insert_registro is

   begin

     babmc.plsu_empr_codi:= V('AI_EMPR_CODI');

     insert into rrhh_plan_suel
        (plsu_codi,
         plsu_desc,
         plsu_empr_codi,
         plsu_codi_alte,
         plsu_gest_conc_codi,
         --plsu_conc_codi,
         plsu_indi_desc_rete,
         plsu_cuco_codi_suel_apag,
         plsu_cuco_codi_suel_jorn,
         plsu_cuco_codi_adel,
         plsu_cuco_codi_boni_fami,
         plsu_cuco_codi_carg_soci,
         plsu_cuco_codi_apor_apag,
         plsu_cuco_codi_vaca,
         plsu_cuco_codi_agui,
         plsu_cuco_codi_hora_extr,
         plsu_cuco_codi_pi,
         plsu_cuco_codi_pe,
         plsu_cuco_codi_viat,
         plsu_cuco_codi_comi)
      values
        (babmc.plsu_codi,
         babmc.plsu_desc,
         babmc.plsu_empr_codi,
         babmc.plsu_codi_alte,
         babmc.plsu_gest_conc_codi,
         --babmc.plsu_conc_codi,
         babmc.plsu_indi_desc_rete,
         babmc.plsu_cuco_codi_suel_apag,
         babmc.plsu_cuco_codi_suel_jorn,
         babmc.plsu_cuco_codi_adel,
         babmc.plsu_cuco_codi_boni_fami,
         babmc.plsu_cuco_codi_carg_soci,
         babmc.plsu_cuco_codi_apor_apag,
         babmc.plsu_cuco_codi_vaca,
         babmc.plsu_cuco_codi_agui,
         babmc.plsu_cuco_codi_hora_extr,
         babmc.plsu_cuco_codi_pi,
         babmc.plsu_cuco_codi_pe,
         babmc.plsu_cuco_codi_viat,
         babmc.plsu_cuco_codi_comi);

   exception
     when others then
       raise_application_error(-20010, 'Error en la insercion tabla Plan Sueldo.! ' ||sqlerrm);
   end pp_insert_registro;

-----------------------------------------------
   procedure pp_insert_bdet is

     v_plco_codi number;

   begin

     for bdet in cur_bdet loop

       select nvl(max(plco_codi),0)+1
        into v_plco_codi
        from rrhh_plan_suel_conc_deta;

       insert into rrhh_plan_suel_conc_deta
          (plco_codi,
           plco_plsu_codi,
           plco_conc_codi)
        values
          (
           v_plco_codi,
           babmc.plsu_codi,--bdet.plco_plsu_codi,
           bdet.plco_conc_codi
           );

     end loop;

   exception
     when others then
       raise_application_error(-20010, 'Error en la insercion en la tabla Sueldo Concepto.! ' ||sqlerrm);
   end pp_insert_bdet;

-----------------------------------------------
  procedure pp_insert_bsele(p_rol in varchar2) is

    cursor c_roles is
      select regexp_substr(p_rol, '[^:]+', 1, level) rol
        from dual
      connect by regexp_substr(p_rol, '[^:]+', 1, level) is not null;

    v_index number := 0;
  begin

    for v in c_roles loop

      v_index := v_index + 1;

      if v.rol is not null then

        insert into rrhh_plan_suel_deta
          (plde_plsu_codi, plde_conc_codi, plde_orden)
        values
          (babmc.plsu_codi, --plde_plsu_codi,
           v.rol, --plde_conc_codi,
           v_index);

      end if;

    end loop;

  exception
    when others then
      raise_application_error(-20010, 'Error en la insercion en la tabla Sueldo Deta.! ' || sqlerrm);

  end pp_insert_bsele;

-----------------------------------------------
  procedure pp_update_registro is

  begin

    update rrhh_plan_suel
       set plsu_codi           = babmc.plsu_codi,
           plsu_desc           = babmc.plsu_desc,
           plsu_empr_codi      = babmc.plsu_empr_codi,
           plsu_codi_alte      = babmc.plsu_codi_alte,
           plsu_gest_conc_codi = babmc.plsu_gest_conc_codi,
           --plsu_conc_codi = babmc.plsu_conc_codi,
           plsu_indi_desc_rete      = babmc.plsu_indi_desc_rete,
           plsu_cuco_codi_suel_apag = babmc.plsu_cuco_codi_suel_apag,
           plsu_cuco_codi_suel_jorn = babmc.plsu_cuco_codi_suel_jorn,
           plsu_cuco_codi_adel      = babmc.plsu_cuco_codi_adel,
           plsu_cuco_codi_boni_fami = babmc.plsu_cuco_codi_boni_fami,
           plsu_cuco_codi_carg_soci = babmc.plsu_cuco_codi_carg_soci,
           plsu_cuco_codi_apor_apag = babmc.plsu_cuco_codi_apor_apag,
           plsu_cuco_codi_vaca      = babmc.plsu_cuco_codi_vaca,
           plsu_cuco_codi_agui      = babmc.plsu_cuco_codi_agui,
           plsu_cuco_codi_hora_extr = babmc.plsu_cuco_codi_hora_extr,
           plsu_cuco_codi_pi        = babmc.plsu_cuco_codi_pi,
           plsu_cuco_codi_pe        = babmc.plsu_cuco_codi_pe,
           plsu_cuco_codi_viat      = babmc.plsu_cuco_codi_viat,
           plsu_cuco_codi_comi      = babmc.plsu_cuco_codi_comi
     where plsu_codi = babmc.plsu_codi;

  exception
    when others then
      raise_application_error(-20010, 'Error al actualizar la tabla Plan Sueldo.! ' || sqlerrm);
  end pp_update_registro;

-----------------------------------------------
  procedure pp_update_bdet is

    v_plco_codi number;

  begin

    for bdet in cur_bdet loop

      if bdet.indicador = 'I' then
        select nvl(max(plco_codi), 0) + 1
          into v_plco_codi
          from rrhh_plan_suel_conc_deta;

        insert into rrhh_plan_suel_conc_deta
          (plco_codi, plco_plsu_codi, plco_conc_codi)
        values
          (v_plco_codi,
           babmc.plsu_codi, --bdet.plco_plsu_codi,
           bdet.plco_conc_codi);

      elsif bdet.indicador = 'U' then
        update rrhh_plan_suel_conc_deta
           set plco_codi      = bdet.plco_codi,
               plco_plsu_codi = bdet.plco_plsu_codi,
               plco_conc_codi = bdet.plco_conc_codi
         where plco_codi      = bdet.plco_codi;

      elsif bdet.indicador = 'D' then
        delete rrhh_plan_suel_conc_deta where plco_codi = bdet.plco_codi;
      else
        null;
      end if;

    end loop;

  exception
    when others then
      raise_application_error(-20010, 'Error al actualizar la tabla Sueldo Concepto.! ' || sqlerrm);
  end pp_update_bdet;

-----------------------------------------------
  procedure pp_update_bsele(p_rol in varchar2) is

    cursor c_roles is
      select regexp_substr(p_rol, '[^:]+', 1, level) rol
        from dual
      connect by regexp_substr(p_rol, '[^:]+', 1, level) is not null;

    v_index           number := 0;
    v_orden           number;
    v_seq             number;
    v_plde_plsu_codi  number;
    v_plde_conc_codi  number;
    i_collection_name varchar2(30) := 'COLL_AUX';
    v_sql             varchar2(3000);

    cursor c_aux is
      select det.seq_id nro,
             c001       plde_plsu_codi,
             c002       plde_conc_codi,
             c003       plde_orden,
             c004       indi
        from apex_collections det
       where det.collection_name = 'COLL_AUX';

  begin

    v_sql := ' select plde_plsu_codi, plde_conc_codi, plde_orden, ' ||
             chr(39) || 'D' || chr(39) ||
             ' indi from rrhh_plan_suel_deta where plde_plsu_codi =' ||
             babmc.plsu_codi;

    if apex_collection.collection_exists(p_collection_name => i_collection_name) then
      apex_collection.delete_collection(p_collection_name => i_collection_name);
    end if;

    apex_collection.create_collection_from_query(p_collection_name => i_collection_name,
                                                 p_query           => v_sql);

    for v in c_roles loop

      v_index := v_index + 1;

      if v.rol is not null then

        begin
          select det.seq_id nro,
                 c001       plde_plsu_codi,
                 c002       plde_conc_codi,
                 c003       plde_orden
            into v_seq, v_plde_plsu_codi, v_plde_conc_codi, v_orden
            from apex_collections det
           where det.collection_name = 'COLL_AUX'
             and c001 = babmc.plsu_codi
             and c002 = v.rol;

          if v_index <> v_orden then
            APEX_COLLECTION.UPDATE_MEMBER(p_collection_name => 'COLL_AUX',
                                          p_seq             => v_seq,
                                          p_c001            => v_plde_plsu_codi,
                                          p_c002            => v_plde_conc_codi,
                                          p_c003            => v_index,
                                          p_c004            => 'U');
          else
            APEX_COLLECTION.UPDATE_MEMBER(p_collection_name => 'COLL_AUX',
                                          p_seq             => v_seq,
                                          p_c001            => v_plde_plsu_codi,
                                          p_c002            => v_plde_conc_codi,
                                          p_c003            => v_orden,
                                          p_c004            => 'T');
          end if;

        exception
          when no_data_found then
            APEX_COLLECTION.ADD_MEMBER(p_collection_name => 'COLL_AUX',
                                       p_c001            => babmc.plsu_codi,
                                       p_c002            => v.rol,
                                       p_c003            => v_index,
                                       p_c004            => 'I');

        end;

      end if;

    end loop;


    for i in c_aux loop

      if i.indi = 'T' then
        null;

      elsif i.indi = 'I' then
        insert into rrhh_plan_suel_deta
          (plde_plsu_codi, plde_conc_codi, plde_orden)
        values
          (i.plde_plsu_codi, i.plde_conc_codi, i.plde_orden);

      elsif i.indi = 'U' then
        update rrhh_plan_suel_deta
           set plde_orden = i.plde_orden
         where plde_plsu_codi = i.plde_plsu_codi
           and plde_conc_codi = i.plde_conc_codi;

      elsif i.indi = 'D' then
        delete rrhh_plan_suel_deta
         where plde_plsu_codi = i.plde_plsu_codi
           and plde_conc_codi = i.plde_conc_codi;

      end if;

    end loop;

  exception
    when others then
      raise_application_error(-20010, 'Error en la insercion en la tabla Sueldo Deta.! ' || sqlerrm);

  end pp_update_bsele;

-----------------------------------------------
  procedure pp_actualizar_registro is

  begin

    pp_cargar_variables;

    if babmc.p_indi = 'I' then

      pp_valida;

      pp_genera_codi_alte;

      pp_generar_codigo;
      pp_insert_registro;
      pp_insert_bdet;
      pp_insert_bsele(babmc.p_roles);
      --apex_application.g_print_success_message :='Registro insertado correctamente!';

    else
      pp_valida;
      pp_update_registro;
      pp_update_bdet;
      pp_update_bsele(babmc.p_roles);
      --apex_application.g_print_success_message :='Registro modificado correctamente!';

    end if;

  exception
    when others then
      rollback;
      raise_application_error(-20010, 'Error.! ' || sqlerrm);

  end pp_actualizar_registro;

--------------------------------------------
  procedure pp_validar_borrado is
    v_count number(6);
  begin

    select count(*)
    into v_count
    from come_empl
    where empl_plsu_codi = babmc.plsu_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'Existen empleados asignados a la plantilla seleccionada!');
    end if;
  end;

--------------------------------------------
  procedure pp_pre_delete is

  begin
      delete from rrhh_plan_suel_deta
      where plde_plsu_codi = babmc.plsu_codi;

      delete from rrhh_plan_suel_conc_deta r
       where r.plco_plsu_codi = babmc.plsu_codi;

  exception
    when others then
        raise_application_error(-20010,'Error en el pre-borrado.! ' ||sqlerrm);

  end pp_pre_delete;

--------------------------------------------
  procedure pp_delete_registros is

  begin

    delete rrhh_plan_suel
    where plsu_codi = babmc.plsu_codi;

  exception
    when others then
        raise_application_error(-20010,'Error al borrar registros.! ' ||sqlerrm);

  end pp_delete_registros;

--------------------------------------------
  procedure pp_borrar_registro is
     e_cod_null exception;

  begin

      babmc.plsu_codi := V('P71_PLSU_CODI');

      if babmc.plsu_codi is null then
        raise e_cod_null;
      end if;

      pp_validar_borrado;
      pp_pre_delete;
      pp_delete_registros;

      --apex_application.g_print_success_message :='Registro eliminado correctamente!';

  exception
    when e_cod_null then
      raise_application_error(-20010,'Debe de seleccionar un registro.! ');
    when others then
      raise_application_error(-20010,'Error al borrar registro.! ' ||sqlerrm);
  end pp_borrar_registro;

--------------------------------------------


end I010438;
