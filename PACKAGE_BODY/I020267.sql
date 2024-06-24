
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020267" is

  e_sin_parametro exception;

  type r_parameter is record(
    p_empr_codi               number := 1,
    p_sose_codi_actu          number,
    p_codi_clas1_clie_subclie number := to_number(general_skn.fl_busca_parametro('p_codi_clas1_clie_subclie')),
    p_peco_codi               number := 1,
    p_codi_base               number := pack_repl.fa_devu_codi_base,
    p_sucu_codi               number);

  parameter r_parameter;

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
  g_imag                varchar2(1000);
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
     where /*clpr_ruc = i_nume_docu
       and */(i_clpr_codi is null or i_clpr_codi <> clpr_codi)
       and clpr_indi_clie_prov = 'C'
       and REGEXP_REPLACE(CASE WHEN INSTR(clpr_ruc, '-') > 0 THEN
                             SUBSTR(clpr_ruc, 1, INSTR(clpr_ruc, '-') - 1)
                            ELSE
                             clpr_ruc
                          END,'[^0-9]','') = REGEXP_REPLACE(CASE WHEN INSTR(i_nume_docu, '-') > 0 THEN
                                                                SUBSTR(i_nume_docu, 1, INSTR(i_nume_docu, '-') - 1)
                                                                 ELSE
                                                                  i_nume_docu
                                                               END, '[^0-9]','');
  
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
         and clpr_indi_clie_prov = 'C' ;
         
        
    
      if v_count > 0 and nvl(i_nume_docu, '-1') <> '44444401-7' then
        raise_application_error(-20011,
                                'Atencion!!! El numero de ' ||
                                nvl(i_tipo_docu, 'R.U.C.') ||
                                ' ingresado se encuentra asignado a otro Cliente');
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
    if v_cant_cont < 2 then
      raise_application_error(-20010,
                              'Debe asignar al menos 2 Referencias Personaless.');
    end if;
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
  

  
    if g_come_soli_serv.sose_mone_codi is null then
      raise_application_error(-20010,
                              'Debe Ingresar la moneda de la Solicitud.');
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
    if nvl(g_soli_serv_clie_dato.sose_tipo_pers, 'F') = 'J' then
      if g_soli_serv_clie_dato.sose_prop_nomb is null then
        raise_application_error(-20010,
                                'Debe Indicar el Nombre del Responsable.');
      end if;
      if g_soli_serv_clie_dato.sose_prop_docu is null then
        raise_application_error(-20010,
                                'Debe Indicar el Documento del Responsable.');
      end if;
    end if;  
       ---------------ticket #349
       /*  
      if g_soli_serv_clie_dato.sose_prop_carg is null then
        raise_application_error(-20010,
                                'Debe Indicar el Cargo del Responsable.');
      end if;
    

    if g_soli_serv_clie_dato.sose_luga_trab is null then
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
    end if;*/
  
    if g_soli_serv_clie_dato.sose_barr_codi is null then
      raise_application_error(-20010, 'Barrio es requerido');
    end if;
  
    pp_valida_ruc(g_soli_serv_clie_dato.sose_docu,
                  g_soli_serv_clie_dato.sose_tipo_docu,
                  g_come_soli_serv.sose_clpr_codi);
  end pp_validaciones;

  procedure pp_valida_borrado is
    v_count number;
  begin
  
    begin
      select count(*)
        into v_count
        from come_soli_serv_anex
       where anex_sose_codi = g_come_soli_serv.sose_codi;
    
      if v_count <> 0 then
        raise_application_error(-20010,
                                'La solicitud no puede ser eliminada. Existe(n) Anexo(s) relacionado(s) a este Contrato!');
      end if;
    end;
  
    begin
      select count(*)
        into v_count
        from come_soli_desi
       where sode_deta_codi in
             (select deta_codi
                from come_soli_serv_anex_deta, come_soli_serv_anex
               where anex_codi = deta_anex_codi
                 and anex_sose_codi = g_come_soli_serv.sose_codi);
      if v_count <> 0 then
        raise_application_error(-20010,
                                'La solicitud no puede ser eliminada. Existe(n) solicitud(es) de desinstalacion relacionada(s) a vehiculos del Contrato!');
      end if;
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
                 and anex_sose_codi = g_come_soli_serv.sose_codi);
      --and sose_tipo not in ('N', 'T', 'R', 'RAS', 'S'));
      if v_count <> 0 then
        raise_application_error(-20010,
                                'La solicitud no puede ser eliminada. Existe(n) Orden(es) de Trabajo relacionada(s) a vehiculos del Contrato!');
      end if;
    end;
  
    begin
      select count(*)
        into v_count
        from come_soli_serv_fact_deta sf
       where sf.sofa_indi_fact <> 'N'
         and sf.sofa_sose_codi = g_come_soli_serv.sose_codi;
    
      if v_count <> 0 then
        raise_application_error(-20010,
                                'La solicitud no puede ser eliminada,ya que posee cuotas facturadas');
      end if;
    end;
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
    if not
        (apex_collection.collection_exists(p_collection_name => 'SOL_REF')) then
      apex_collection.create_collection(p_collection_name => 'SOL_REF');
    end if;
  
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
    --   clpr_empl_codi,
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
       clpr_base)
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
     --  null,
       fa_user,
       sysdate,
       g_soli_serv_clie_dato.sose_prop_nomb,
       g_soli_serv_clie_dato.sose_prop_docu,
       g_soli_serv_clie_dato.sose_prop_nomb_2,
       g_soli_serv_clie_dato.sose_prop_docu_2,
       v_clpr.clpr_orte_codi,
       v_clpr.clpr_sucu_codi,
       1,
       'N',
       v_clpr.clpr_base);
  
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
       fa_user, --fapa_user_regi,
       sysdate, --fapa_fech_regi,
       nvl(i_empresa, 1), --fapa_empr_codi,
       v_clpr.clpr_base --fapa_base
       );
  
  end pp_genera_nuevo_cliente;

  procedure pp_borrar_ref(i_seq_id in number) as
  begin
  
    apex_collection.delete_member(p_collection_name => 'SOL_REF',
                                  p_seq             => i_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'SOL_REF');
  
  end pp_borrar_ref;

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
       fa_user,
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

  procedure pp_ejecuta_consulta_soli_dato(i_sose_codi           in number,
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
  
    /* o_sucu_nume_item_orig := v_cli_prov.clpr_codi_alte;
    o_sucu_nume_item      := v_cli_prov.clpr_codi_alte;
    o_clas1_codi_alte     := v_cli_prov.clpr_codi_alte;*/
    for r in cv_refe loop
    
      pp_add_referencia(i_ref_desc => r.refe_desc,
                        i_ref_tel  => r.refe_tele);
    end loop;
  
    /*   select clpr_desc clpr_desc,
            nvl(clpr_tipo_pers, 'F') tipo_persona,
            clpr_clie_clas1_codi clasificacion
       from come_clie_prov
      where clpr_indi_clie_prov = 'C'
        and clpr_codi = :p47_sose_clpr_codi;
    */
  
    /*pp_setear_tipo_persona;*/
  
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
  end pp_ejecuta_consulta_soli_dato;

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
             fa_user,
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
    v_sose_user_modi                := fa_user;
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
      if g_soli_serv_clie_dato.sose_desc is not null then
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
      end if;
    
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
      end if;
    
      if g_soli_serv_clie_dato.sose_esta_civi is not null then
        update come_clie_prov
           set clpr_esta_civi = g_soli_serv_clie_dato.sose_esta_civi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_sexo is not null then
        update come_clie_prov
           set clpr_sexo = g_soli_serv_clie_dato.sose_sexo
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_fech_naci is not null then
        update come_clie_prov
           set clpr_fech_naci = g_soli_serv_clie_dato.sose_fech_naci
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
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
      
        update come_clie_fact_pago
           set fapa_emai_fact = g_soli_serv_clie_dato.sose_email_fact
         where fapa_clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_mepa_codi is not null then
        update come_clie_prov
           set clpr_mepa_codi = g_soli_serv_clie_dato.sose_mepa_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_naci_codi is not null then
        update come_clie_prov
           set clpr_naci_codi = g_soli_serv_clie_dato.sose_naci_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_zona_codi is not null then
        update come_clie_prov
           set clpr_zona_codi = g_soli_serv_clie_dato.sose_zona_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
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
    
      if g_soli_serv_clie_dato.sose_prop_nomb is not null then
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
      end if;
    
      if g_soli_serv_clie_dato.sose_prof_codi is not null then
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
      end if;
    
      if g_soli_serv_clie_dato.sose_refe_dire is not null then
        update come_clie_prov
           set clpr_refe_dire = g_soli_serv_clie_dato.sose_refe_dire
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
    v_barrio_des varchar2(1000);
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
    v_barrio_des       := g_soli_serv_clie_dato.sose_barrio_des;
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
       v_barrio_des,
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
    
  v_cant_anex_pend number;
  v_cant_anex_apro number;
  v_cant_anex number;
    --v_indi varchar2(1);
  begin
    --si no es un cliente nuevo debe actualizar los datos
   
    /*19/05/20233 Programacion #696 Para clientes antiguos . El asesor puede cambiar datos de 
    clientes que tengan anexo pendiente y una vez que se autoriza, actualiza la ficha de clientes.*/  

    


   if g_come_soli_serv.sose_clpr_codi is not null then
  
        select count(*)
           into v_cant_anex
        from  come_soli_serv_anex d
        where d.anex_sose_codi =g_come_soli_serv.sose_codi ;  
 
  
      --if g_come_soli_serv.sose_fech_regi < '01/01'||To_char(sysdate,'yyyy') then
         select count(*)
           into v_cant_anex_pend
        from  come_soli_serv_anex d
        where d.anex_sose_codi =g_come_soli_serv.sose_codi
        and nvl(d.anex_esta,'P') = 'P' ;  
        
         select count(*)
           into v_cant_anex_apro
        from  come_soli_serv_anex d
        where d.anex_sose_codi =g_come_soli_serv.sose_codi
        and nvl(d.anex_esta,'P') = 'A' ;  
  
   if v_cant_anex = 0 then
    null;
  
   elsif v_cant_anex >0 and v_cant_anex_pend = 0 then
     raise_application_error(-20001, 'La solicitud no tiene ningun anexo en estado pendiente, por ese motivo no se puede modificar');
   end if;
  -- end if;
  
   
  -- end if;
     if v_cant_anex >0 then
         null;--la ficha del cliente se actualizara cuando se apruebe el anexo de contrato
      else
       
         pp_actualiza_datos_cliente;
     end if;
   end if;
 
  
    if w_indi_oper = 'I' or (g_come_soli_serv.sose_codi is null and
       g_come_soli_serv.sose_nume is not null) then
      pp_inse_dato_soli_serv;
    elsif w_indi_oper = 'U' or (g_come_soli_serv.sose_codi is not null and
          g_come_soli_serv.sose_nume is not null) then
      pp_actu_dato_soli_serv(g_come_soli_serv.sose_codi); --actualiza datos de cabecera de solicitud
    end if;
  
  
  
   if g_come_soli_serv.sose_clpr_codi_refe is not null and g_imag  is null then
       raise_application_error(-20001,'Debe cargar la imagen de la refencia cliente');
     end if; 
     
     
    --------------AGEREGAR IMAGEN
   DECLARE 
     v_archivo    blob;
    v_mime_type  varchar2(2000);
    v_filename   varchar2(2000);
    v_file_id    number;
  begin
  ---raise_application_error(-20001,g_imag);
    begin
    
     SELECT blob_content, mime_type, filename
      INTO v_archivo,v_mime_type, v_filename
      FROM APEX_APPLICATION_FILES A
     WHERE A.NAME = g_imag 
       AND ROWNUM = 1;
     -- raise_application_error(-20001,v_archivo);    
        update COME_SOLI_SERV
         set SOSE_REFE_FILE_IMAG = v_archivo,
             SOSE_REFE_FILE_MIME = v_mime_type,
             SOSE_REFE_FILE_NAME = v_filename
       where SOSE_CODI = g_come_soli_serv.sose_codi;
    exception
      when others then
        null;
    end;
     -- raise_application_error(-20001,v_mime_type);    
   END;
      if g_come_soli_serv.sose_clpr_codi_refe is null  then
     update COME_SOLI_SERV
         set SOSE_REFE_FILE_IMAG = null,
             SOSE_REFE_FILE_MIME = null,
             SOSE_REFE_FILE_NAME = null
       where SOSE_CODI = g_come_soli_serv.sose_codi;
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

  procedure pp_set_variables as
    v_sose_nume varchar2(300);
  begin
     if v('P47_SOSE_NUME') = '_____________' then
      v_sose_nume := null;
     else
       v_sose_nume := v('P47_SOSE_NUME');
     end if;
    g_come_soli_serv.sose_codi                := v('P47_SOSE_CODI');
    g_come_soli_serv.sose_clpr_codi           := v('P47_SOSE_CLPR_CODI');
    g_come_soli_serv.sose_nume                := v_sose_nume;--v('P47_SOSE_NUME');
    g_come_soli_serv.sose_desc                := v('P47_SOSE_DESC');
    g_come_soli_serv.sose_fech_emis           := v('P47_SOSE_FECH_EMIS');
    g_come_soli_serv.sose_mone_codi           := v('P47_SOSE_MONE_CODI');
    g_come_soli_serv.sose_impo_mone           := v('P47_SOSE_IMPO_MONE');
    g_come_soli_serv.sose_impo_mmnn           := v('P47_SOSE_IMPO_MMNN');
    g_come_soli_serv.sose_tasa_mone           := v('P47_SOSE_TASA_MONE');
    g_come_soli_serv.sose_sucu_codi           := v('P47_SOSE_SUCU_CODI');
    g_come_soli_serv.sose_movi_codi           := v('P47_SOSE_MOVI_CODI');
    g_come_soli_serv.sose_obse                := v('P47_SOSE_OBSE');
    g_come_soli_serv.sose_user_regi           := v('P47_SOSE_USER_REGI');
    g_come_soli_serv.sose_fech_regi           := v('P47_SOSE_FECH_REGI');
    g_come_soli_serv.sose_user_modi           := v('P47_SOSE_USER_MODI');
    g_come_soli_serv.sose_fech_modi           := v('P47_SOSE_FECH_MODI');
    g_come_soli_serv.sose_esta                := v('P47_SOSE_ESTA');
    g_come_soli_serv.sose_clpr_codi_aseg      := v('P47_SOSE_CLPR_CODI_ASEG');
    g_come_soli_serv.sose_indi_timo           := v('P47_SOSE_INDI_TIMO');
    g_come_soli_serv.sose_tipo                := v('P47_SOSE_TIPO');
    g_come_soli_serv.sose_nume_poli           := v('P47_SOSE_NUME_POLI');
    g_come_soli_serv.sose_orte_codi           := v('P47_SOSE_ORTE_CODI');
    g_come_soli_serv.sose_calc_gran           := v('P47_SOSE_CALC_GRAN');
    g_come_soli_serv.sose_calc_pequ           := v('P47_SOSE_CALC_PEQU');
    g_come_soli_serv.sose_ning_calc           := v('P47_SOSE_NING_CALC');
    g_come_soli_serv.sose_indi_moni           := v('P47_SOSE_INDI_MONI');
    g_come_soli_serv.sose_indi_nexo_recu      := v('P47_SOSE_INDI_NEXO_RECU');
    g_come_soli_serv.sose_indi_para_moto      := v('P47_SOSE_INDI_PARA_MOTO');
    g_come_soli_serv.sose_indi_boto_esta      := v('P47_SOSE_INDI_BOTO_ESTA');
    g_come_soli_serv.sose_indi_acce_aweb      := v('P47_SOSE_INDI_ACCE_AWEB');
    g_come_soli_serv.sose_indi_roam           := v('P47_SOSE_INDI_ROAM');
    g_come_soli_serv.sose_tipo_roam           := v('P47_SOSE_TIPO_ROAM');
    g_come_soli_serv.sose_indi_boto_pani      := v('P47_SOSE_INDI_BOTO_PANI');
    g_come_soli_serv.sose_indi_mant_equi      := v('P47_SOSE_INDI_MANT_EQUI');
    g_come_soli_serv.sose_indi_cort_corr_auto := v('P47_SOSE_INDI_CORT_CORR_AUTO');
    g_come_soli_serv.sose_indi_avis_poli      := v('P47_SOSE_INDI_AVIS_POLI');
    g_come_soli_serv.sose_indi_auto_dete_vehi := v('P47_SOSE_INDI_AUTO_DETE_VEHI');
    g_come_soli_serv.sose_inst_espe           := v('P47_SOSE_INST_ESPE');
    g_come_soli_serv.sose_prec_unit           := v('P47_SOSE_PREC_UNIT');
    g_come_soli_serv.sose_valo_tota           := v('P47_SOSE_VALO_TOTA');
    g_come_soli_serv.sose_fech_vige           := v('P47_SOSE_FECH_VIGE');
    g_come_soli_serv.sose_dura_cont           := v('P47_SOSE_DURA_CONT');
    g_come_soli_serv.sose_cant_movi           := v('P47_SOSE_CANT_MOVI');
    g_come_soli_serv.sose_equi_prec           := v('P47_SOSE_EQUI_PREC');
    g_come_soli_serv.sose_tipo_fact           := v('P47_SOSE_TIPO_FACT');
    g_come_soli_serv.sose_entr_inic           := v('P47_SOSE_ENTR_INIC');
    g_come_soli_serv.sose_impu_codi           := v('P47_SOSE_IMPU_CODI');
    g_come_soli_serv.sose_cost_mone_pres      := v('P47_SOSE_COST_MONE_PRES');
    g_come_soli_serv.sose_impo_mone_fact      := v('P47_SOSE_IMPO_MONE_FACT');
    g_come_soli_serv.sose_impo_mone_fact_ii   := v('P47_SOSE_IMPO_MONE_FACT_II');
    g_come_soli_serv.sose_porc_cost           := v('P47_SOSE_PORC_COST');
    g_come_soli_serv.sose_tipo_serv           := v('P47_SOSE_TIPO_SERV');
    g_come_soli_serv.sose_clco_codi           := v('P47_SOSE_CLCO_CODI');
    g_come_soli_serv.sose_fech_liqu           := v('P47_SOSE_FECH_LIQU');
    g_come_soli_serv.sose_asie_codi_liqu      := v('P47_SOSE_ASIE_CODI_LIQU');
    g_come_soli_serv.sose_cost_mone_pres_ii   := v('P47_SOSE_COST_MONE_PRES_II');
    g_come_soli_serv.sose_nume_orde_serv      := v('P47_SOSE_NUME_ORDE_SERV');
    g_come_soli_serv.sose_clpr_codi_orig      := v('P47_SOSE_CLPR_CODI_ORIG');
    g_come_soli_serv.sose_sucu_nume_item_orig := v('P47_SOSE_SUCU_NUME_ITEM_ORIG');
    g_come_soli_serv.sose_roam_fech_inic_vige := v('P47_SOSE_ROAM_FECH_INIC_VIGE');
    g_come_soli_serv.sose_roam_fech_fini_vige := v('P47_SOSE_ROAM_FECH_FINI_VIGE');
    g_come_soli_serv.sose_sucu_nume_item      := v('P47_SOSE_SUCU_NUME_ITEM');
    g_come_soli_serv.sose_fech_inic_vige      := v('P47_SOSE_FECH_INIC_VIGE');
    g_come_soli_serv.sose_codi_ante           := v('P47_SOSE_CODI_ANTE');
    g_come_soli_serv.sose_tipo_acce           := v('P47_SOSE_TIPO_ACCE');
    g_come_soli_serv.sose_indi_sens_tapa_tanq := v('P47_SOSE_INDI_SENS_TAPA_TANQ');
    g_come_soli_serv.sose_indi_sens_comb      := v('P47_SOSE_INDI_SENS_COMB');
    g_come_soli_serv.sose_indi_sens_temp      := v('P47_SOSE_INDI_SENS_TEMP');
    g_come_soli_serv.sose_indi_aper_puer      := v('P47_SOSE_INDI_APER_PUER');
    g_come_soli_serv.sose_clav_conf           := v('P47_SOSE_CLAV_CONF');
    g_come_soli_serv.sose_corr_info_even      := v('P47_SOSE_CORR_INFO_EVEN');
    g_come_soli_serv.sose_esta_veri           := v('P47_SOSE_ESTA_VERI');
    g_come_soli_serv.sose_dire_obse           := v('P47_SOSE_DIRE_OBSE');
    g_come_soli_serv.sose_fech_auto           := v('P47_SOSE_FECH_AUTO');
    g_come_soli_serv.sose_user_auto           := v('P47_SOSE_USER_AUTO');
    g_come_soli_serv.sose_codi_padr           := v('P47_SOSE_CODI_PADR');
    g_come_soli_serv.sose_fech_inic_poli      := v('P47_SOSE_FECH_INIC_POLI');
    g_come_soli_serv.sose_fech_fini_poli      := v('P47_SOSE_FECH_FINI_POLI');
    g_come_soli_serv.sose_indi_migr           := v('P47_SOSE_INDI_MIGR');
    g_come_soli_serv.sose_indi_reno           := v('P47_SOSE_INDI_RENO');
    g_come_soli_serv.sose_orcl_codi           := v('P47_SOSE_ORCL_CODI');
    g_come_soli_serv.sose_base                := parameter.p_codi_base;
    g_come_soli_serv.sose_empr_codi           := parameter.p_empr_codi;
    --v('P47_SOSE_EMPR_CODI');

    ----------**************************
    g_soli_serv_clie_dato.sose_codi           := v('P47_SOSE_CODI');
    g_soli_serv_clie_dato.sose_indi_dato      := v('P47_SOSE_INDI_DATO');
    g_soli_serv_clie_dato.sose_nomb           := v('P47_SOSE_NOMB');
    g_soli_serv_clie_dato.sose_apel           := v('P47_SOSE_APEL');
    g_soli_serv_clie_dato.sose_tipo_docu      := v('P47_SOSE_TIPO_DOCU');
    g_soli_serv_clie_dato.sose_docu           := v('P47_SOSE_DOCU');
    g_soli_serv_clie_dato.sose_esta_civi      := v('P47_SOSE_ESTA_CIVI');
    g_soli_serv_clie_dato.sose_fech_naci      := v('P47_SOSE_FECH_NACI');
    g_soli_serv_clie_dato.sose_dire           := v('P47_SOSE_DIRE');
    g_soli_serv_clie_dato.sose_tele_part      := v('P47_SOSE_TELE_PART');
    g_soli_serv_clie_dato.sose_naci_codi      := v('P47_SOSE_NACI_CODI');
    g_soli_serv_clie_dato.sose_zona_codi      := v('P47_SOSE_ZONA_CODI');
    g_soli_serv_clie_dato.sose_barr_codi      := v('P47_SOSE_BARR_CODI');
    g_soli_serv_clie_dato.sose_barrio_des     := v('P47_SOSE_BARRIO_DES');
    g_soli_serv_clie_dato.sose_ciud_codi      := v('P47_SOSE_CIUD_CODI');
    g_soli_serv_clie_dato.sose_dist           := v('P47_SOSE_DIST');
    g_soli_serv_clie_dato.sose_inmu_prop      := v('P47_SOSE_INMU_PROP');
    g_soli_serv_clie_dato.sose_nume_finc      := v('P47_SOSE_NUME_FINC');
    g_soli_serv_clie_dato.sose_luga_trab      := v('P47_SOSE_LUGA_TRAB');
    g_soli_serv_clie_dato.sose_tele_trab      := v('P47_SOSE_TELE_TRAB');
    g_soli_serv_clie_dato.sose_anti           := v('P47_SOSE_ANTI');
    g_soli_serv_clie_dato.sose_pues_trab      := v('P47_SOSE_PUES_TRAB');
    g_soli_serv_clie_dato.sose_nomb_cony      := v('P47_SOSE_NOMB_CONY');
    g_soli_serv_clie_dato.sose_tele_cony      := v('P47_SOSE_TELE_CONY');
    g_soli_serv_clie_dato.sose_cedu_cony      := v('P47_SOSE_CEDU_CONY');
    g_soli_serv_clie_dato.sose_acti_cony      := v('P47_SOSE_ACTI_CONY');
    g_soli_serv_clie_dato.sose_luga_trab_cony := v('P47_SOSE_LUGA_TRAB_CONY');
    g_soli_serv_clie_dato.sose_sexo           := v('P47_SOSE_SEXO');
    g_soli_serv_clie_dato.sose_email          := v('P47_SOSE_EMAIL');
    g_soli_serv_clie_dato.sose_prof_codi      := v('P47_SOSE_PROF_CODI');
    g_soli_serv_clie_dato.sose_prop_nomb      := v('P47_SOSE_PROP_NOMB');
    g_soli_serv_clie_dato.sose_prop_docu      := v('P47_SOSE_PROP_DOCU');
    g_soli_serv_clie_dato.sose_prop_nomb_2    := v('P47_SOSE_PROP_NOMB_2');
    g_soli_serv_clie_dato.sose_prop_docu_2    := v('P47_SOSE_PROP_DOCU_2');
    g_soli_serv_clie_dato.sose_prop_carg      := v('P47_SOSE_PROP_CARG');
    g_soli_serv_clie_dato.sose_prop_carg_2    := v('P47_SOSE_PROP_CARG_2');
    g_soli_serv_clie_dato.sose_tipo_pers      := v('P47_SOSE_TIPO_PERS');
    g_soli_serv_clie_dato.sose_mepa_codi      := v('P47_SOSE_MEPA_CODI');
    g_soli_serv_clie_dato.sose_celu           := v('P47_SOSE_CELU');
    g_soli_serv_clie_dato.sose_cont_desc      := v('P47_SOSE_CONT_DESC');
    g_soli_serv_clie_dato.sose_cont_tele      := v('P47_SOSE_CONT_TELE');
    g_soli_serv_clie_dato.sose_cont_emai      := v('P47_SOSE_CONT_EMAI');
    g_soli_serv_clie_dato.sose_email_fact     := v('P47_SOSE_EMAIL_FACT');
    g_soli_serv_clie_dato.sose_refe_dire      := v('P47_SOSE_REFE_DIRE');
    g_soli_serv_clie_dato.SOSE_UBICACION      := v('P47_SOSE_UBICACION');
    
    g_soli_serv_clie_dato.sose_base           := parameter.p_codi_base;
    --g_soli_serv_clie_dato.sose_desc := v('P47_SOSE_DESC');
    g_soli_serv_clie_dato.sose_desc := g_soli_serv_clie_dato.sose_nomb || ' ' ||
                                       g_soli_serv_clie_dato.sose_apel;
     ------*******************************
    --g_borrar_ref               := v('P47_BORRAR_REF');
    g_s_sose_estado       := v('P47_SOSE_ESTA');--v('P47_S_SOSE_ESTADO');
    g_sose_nume_padr      := v('P47_SOSE_NUME_PADR');
    g_clpr_codi_alte_orig := v('P47_CLPR_CODI_ALTE_ORIG');
    --g_clpr_codi_alte_orig_desc := v('P47_CLPR_CODI_ALTE_ORIG_DESC');
    g_sucu_nume_item_orig := v('P47_SUCU_NUME_ITEM_ORIG');
    g_clpr_codi_alte      := v('P47_CLPR_CODI_ALTE');
    --g_clpr_codi_alte_desc      := v('P47_CLPR_CODI_ALTE_DESC');
    g_sucu_nume_item := v('P47_SUCU_NUME_ITEM');
    g_mepa_codi_alte := v('P47_MEPA_CODI_ALTE');
    --g_sose_mepa_codi_desc      := v('P47_SOSE_MEPA_CODI_DESC');
    --g_sose_empl_desc           := v('P47_SOSE_EMPL_DESC');
    
  
    g_naci_codi_alte  := v('P47_NACI_CODI_ALTE');
    g_zona_codi_alte  := v('P47_ZONA_CODI_ALTE');
  --   raise_application_error(-20010,  v('P47_PROF_CODI_ALTE'));
  
    g_prof_codi_alte  := v('P47_PROF_CODI_ALTE');
    
    g_ciud_codi_alte  := v('P47_CIUD_CODI_ALTE');
    g_clas1_codi_alte := v('P47_CLAS1_CODI_ALTE');
    g_barr_codi_alte  := v('P47_BARR_CODI_ALTE');
   
   g_imag :=  v('P47_SOSE_REFE_FILE_IMAG');
   
    if v('REQUEST') = 'UPDATE' then
      w_indi_oper := 'U';
    else
      w_indi_oper := 'I';
    end if;
  
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
  
    pp_barrio_codi(g_barr_codi_alte, g_soli_serv_clie_dato.sose_barr_codi);
  
    pp_profesion_codi(g_prof_codi_alte,
                      g_soli_serv_clie_dato.sose_prof_codi);
  
    pp_cliente_codi(i_clpr_codi_alte => v('P47_CLPR_CODI_ALTE_REFE'),
                    o_sose_clpr_codi => g_come_soli_serv.sose_clpr_codi_refe);
  
    -- v('P47_SOSE_CLPR_CODI_REFE');
  
  end pp_set_variables;

  procedure pp_actualizar_registro is
    salir exception;
    v_sose_codi number;
  begin
 
    
    pp_set_variables;
    
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
    
    
    i010346.pp_valida_ruc(p_nume_docu => g_soli_serv_clie_dato.sose_docu,
                        p_tipo_docu => g_soli_serv_clie_dato.sose_tipo_docu,
                        p_clpr_codi => g_come_soli_serv.sose_clpr_codi);


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

  procedure pp_borrar_registro is
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
   
   
  update extr_rege_link r
     set r.regi_solicitud = null,
         r.regi_expo_soli = null
   where regi_solicitud = g_come_soli_serv.sose_codi;
   
   
 
  
    apex_application.g_print_success_message := 'Registro eliminado.';
  
  
  
  
  exception
    when salir then
      null;
      when others then
        raise_Application_error(-20001,sqlerrm);
  end pp_borrar_registro;

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
  
  
 function fp_formatear_telefono(p_numero in varchar2) return varchar2  is
  
numero  varchar2(50):=p_numero;
v_nro_cel varchar2(50);
v_nro_tel varchar2(50);
l_telefono_formateado VARCHAR2(5000);
BEGIN
      -----------en caso de telefono celular 
        if numero like  '5959%'  then 
          v_nro_cel := 0||replace (numero, '595','');
        elsif numero like  '+5959%' then
          v_nro_cel := 0||replace (numero, '+595','');
        elsif  numero like  '099%' then
          v_nro_cel :=numero;
        elsif  numero like '098%' then
          v_nro_cel :=numero;
        elsif  numero like '097%' then
          v_nro_cel :=numero;
        elsif  numero like '096%' then
          v_nro_cel :=numero;
        elsif  numero like '99%'  then
          v_nro_cel := 0||numero;
        elsif  numero like '98%'  then
          v_nro_cel := 0||numero;
        elsif  numero like '97%' then
          v_nro_cel := 0||numero;
        elsif  numero like '96%'  then
          v_nro_cel := 0||numero;
        end if;
     -------------------------si es linea baja 
     
     if v_nro_cel  is null  then
       numero := regexp_replace(numero,'[^0-9]');
           if  numero not like '0%' then
             v_nro_tel :=0||numero;
            else
             v_nro_tel := numero;
            end if;
            
          if v_nro_tel  like '021%' 
          or v_nro_tel  like '072%' 
          or v_nro_tel  like '038%'
          or v_nro_tel  like '071%'
          or v_nro_tel  like '061%'
          or v_nro_tel  like '032%'
          or v_nro_tel  like '041%' 
          or v_nro_tel  like '047%'
          or v_nro_tel  like '046%'
          or v_nro_tel  like '073%'
          or v_nro_tel  like '081%'
          or v_nro_tel  like '044%'
          or v_nro_tel  like '083%'
          or v_nro_tel  like '039%'  then
           if length(v_nro_tel) >9 then
               l_telefono_formateado :=0||replace(SUBSTR(v_nro_tel, 1, 3) ,0)|| '-' ||SUBSTR(v_nro_tel, 4, 3) || '-' || SUBSTR(v_nro_tel, 7);  
           elsif length(v_nro_tel) =8 then
               l_telefono_formateado :=0||replace(SUBSTR(v_nro_tel, 1, 3) ,0)|| '-' ||SUBSTR(v_nro_tel, 4, 2) || '-' || SUBSTR(v_nro_tel, 6);
           elsif length(v_nro_tel) = 9 then
               l_telefono_formateado :=0||replace(SUBSTR(v_nro_tel, 1, 3) ,0)|| '-' ||SUBSTR(v_nro_tel, 4, 3) || '-' || SUBSTR(v_nro_tel, 7);
             end if;
             
        else
            if length(v_nro_tel) >10 then
               l_telefono_formateado :=0||replace(SUBSTR(v_nro_tel, 1, 4) ,0)|| '-' ||SUBSTR(v_nro_tel, 5, 3) || '-' || SUBSTR(v_nro_tel, 8);  
           elsif length(v_nro_tel) = 9 then
               l_telefono_formateado :=0||replace(SUBSTR(v_nro_tel, 1, 4) ,0)|| '-' ||SUBSTR(v_nro_tel, 5, 2) || '-' || SUBSTR(v_nro_tel, 7);
            elsif length(v_nro_tel) = 10 then
               l_telefono_formateado :=0||replace(SUBSTR(v_nro_tel, 1, 4) ,0)|| '-' ||SUBSTR(v_nro_tel, 5, 2) || '-' || SUBSTR(v_nro_tel, 7);
          
            end if;
             
             
        end if;

     end if; 
      
 if v_nro_cel is not null then
  v_nro_cel := regexp_replace(v_nro_cel,'[^0-9]');

  l_telefono_formateado :=0||replace(SUBSTR(v_nro_cel, 1, 4) ,0)|| '-' ||SUBSTR(v_nro_cel, 5, 3) || '-' || SUBSTR(v_nro_cel, 8);

 end if;
 
 if p_numero like '%/%' then
   l_telefono_formateado := p_numero;
 end if;
 
     return l_telefono_formateado;
end fp_formatear_telefono;


end i020267;
