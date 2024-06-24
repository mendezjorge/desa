
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010054" is

  type r_variable is record(
    movi_fech_emis           come_movi.movi_fech_emis%type,
    movi_clpr_codi           come_movi.movi_clpr_codi%type,
    movi_sucu_codi_orig      come_movi.movi_sucu_codi_orig%type,
    movi_mone_codi           come_movi.movi_mone_codi%type,
    movi_nume                come_movi.movi_nume%type,
    movi_tasa_mone           come_movi.movi_tasa_mone%type,
    movi_clpr_desc           come_movi.movi_clpr_desc%type,
    movi_empr_codi           come_movi.movi_empr_codi%type,
    movi_impo_inte_mmnn      come_movi.movi_impo_inte_mmnn%type,
    sucu_nume_item           number,
    movi_codi                come_movi.movi_codi%type,
    movi_impo_inte_mone      come_movi.movi_impo_inte_mone%type,
    movi_empl_codi           come_movi.movi_empl_codi%type,
    sum_impo_pago            number,
    s_dife                   number,
    movi_timo_indi_adel      varchar2(5),
    movi_timo_indi_ncr       varchar2(5),
    calc_rete                varchar2(2),
    sum_impo_rete_mone       number,
    movi_mone_cant_deci      number,
    impu_porc                number,
    impu_porc_base_impo      number,
    p_para_inic              varchar2(5),
    impu_indi_baim_impu_incl number,
    w_movi_fech_emis         date,
    cuot_impu_codi           number,
    movi_tico_codi           number,
    s_total                  number,
    s_impo_rete_rent         number,
    movi_fech_apli           date,
    impo_rete_mone           number,
    movi_codi_apli           number,
    movi_codi_fact           number);
  bcab r_variable;

  type r_retencion is record(
    movi_nume_rete           number,
    movi_nume_timb_rete      number,
    movi_fech_venc_timb_rete date,
    movi_obse                varchar2(2000));
  rete r_retencion;

  type r_parameter is record(
    p_peco_codi         number := 1,
    p_codi_timo_rcnadle number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadle')),
    p_codi_timo_rcnadlr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadlr')),
    
    --recibo de cn notas de cred. de clientes y proveedores  
    p_codi_timo_cnncre number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncre')),
    p_codi_timo_cnncrr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncrr')),
    
    --recibo de cn de facturas emitidas y recibidas
    p_codi_timo_cnfcrr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcrr')),
    p_codi_timo_cnfcre number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcre')),
    
    p_codi_impu_exen number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_mone_mmnn number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    
    p_cant_deci_mmnn      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_codi_timo_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_imp_min_aplic_reten number := to_number(general_skn.fl_busca_parametro('p_imp_min_aplic_reten')),
    p_porc_aplic_reten    number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten')),
    p_codi_conc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
    p_form_impr_rete      varchar2(5) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_rete'))),
    p_codi_prov_espo      number := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo')),
    p_nave_dato_rete      varchar2(5) := ltrim(rtrim(general_skn.fl_busca_parametro('p_nave_dato_rete'))),
    p_indi_nave_dato_rete varchar2(1) := 'N',
    p_form_calc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
    
    p_indi_porc_rete_sucu varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_porc_rete_sucu'))),
    
    p_indi_rete_tesaka varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_rete_tesaka'))),
    
    p_canc_codi_fcrr number,
    p_movi_codi_rete number,
    p_movi_nume_rete number,
    p_emit_reci      varchar2(2) := 'E'
    
    );

  parameter r_parameter;

  procedure pp_actualizar_situacion(p_desi_codi in number,
                                    p_porc_desc in number,
                                    p_fech_desd in date,
                                    p_fech_hast in date,
                                    p_situ      in varchar2) is
    v_desi_codigo    number;
    v_cant_situ      number;
    v_situ_desc      varchar2(300);
    v_user           varchar2(60) := gen_user;
    v_desi_fech_grab date;
    v_desi_user_grab varchar2(60);
  begin
  
    if p_fech_desd is null then
      raise_application_error(-20001,
                              'La fecha desde no puede quedar vacia');
    end if;
    if p_fech_hast is null then
      raise_application_error(-20001,
                              'La fecha hasta no puede quedar vacia');
    end if;
    if p_fech_desd > p_fech_hast then
      raise_application_error(-20001,
                              'La fecha desde no puede ser mayor a la fecha hasta');
    end if;
    if p_porc_desc is null then
      raise_application_error(-20001,
                              'El porcentaje descuento no puede quedar vacio');
    end if;
    if p_situ is null then
      raise_application_error(-20001,
                              'Debe elegir por lo menos una situacion');
    end if;
  
    if p_desi_codi is null then
    
      select nvl(max(desi_codigo), 0) + 1
        into v_desi_codigo
        from come_desc_situ;
    
      for x in (select regexp_substr(p_situ, '[^:]+', 1, level) situacion
                  from dual
                connect by level <= regexp_count(p_situ, ':') + 1) loop
      
        select count(*)
          into v_cant_situ
          from COME_DESC_SITU
         where desi_situ_codi = x.situacion
           and (p_fech_desd between desi_fech_desd and desi_fech_hast or
               p_fech_hast between desi_fech_desd and desi_fech_hast);
      
        if v_cant_situ > 0 then
          select situ_desc
            into v_situ_desc
            from come_situ_clie
           where situ_codi = x.situacion;
        
          raise_application_error(-20001,
                                  'La situacion: ' || v_situ_desc ||
                                  ' ya tiene un descuento para el rango de fecha agregado');
        end if;
      
        insert into come_desc_situ
          (desi_codigo,
           desi_situ_codi,
           desi_situ_proc,
           desi_fech_desd,
           desi_fech_hast,
           desi_fech_grab,
           desi_user_grab)
        values
          (v_desi_codigo,
           x.situacion,
           p_porc_desc,
           p_fech_desd,
           p_fech_hast,
           sysdate,
           v_user);
      end loop;
    
    else
    
      select desi_fech_grab, desi_user_grab
        into v_desi_fech_grab, v_desi_user_grab
        from come_desc_situ
       where desi_codigo = p_desi_codi
       group by desi_fech_grab, desi_user_grab;
    
      delete come_desc_situ where desi_codigo = p_desi_codi;
    
      for x in (select regexp_substr(p_situ, '[^:]+', 1, level) situacion
                  from dual
                connect by level <= regexp_count(p_situ, ':') + 1) loop
      
        select count(*)
          into v_cant_situ
          from COME_DESC_SITU
         where desi_situ_codi = x.situacion
           and (p_fech_desd between desi_fech_desd and desi_fech_hast or
               p_fech_hast between desi_fech_desd and desi_fech_hast);
      
        if v_cant_situ > 0 then
          select situ_desc
            into v_situ_desc
            from come_situ_clie
           where situ_codi = x.situacion;
        
          raise_application_error(-20001,
                                  'La situacion: ' || v_situ_desc ||
                                  ' ya tiene un descuento para el rango de fecha agregado');
        end if;
        insert into come_desc_situ
          (desi_codigo,
           desi_situ_codi,
           desi_situ_proc,
           desi_fech_desd,
           desi_fech_hast,
           desi_fech_grab,
           desi_user_grab,
           desi_fech_modi,
           desi_user_modi)
        values
          (p_desi_codi,
           x.situacion,
           p_porc_desc,
           p_fech_desd,
           p_fech_hast,
           v_desi_fech_grab,
           v_desi_user_grab,
           sysdate,
           v_user);
      end loop;
    end if;
  
  end pp_actualizar_situacion;

  procedure pp_borrar_registro(p_desi_codi in number) is
  
  begin
  
    delete come_desc_situ where desi_codigo = p_desi_codi;
  
  end pp_borrar_registro;

  procedure pp_add_clie(p_clie      in number,
                        p_codi_come in number,
                        p_fech_desd in date,
                        p_fech_hast in date,
                        p_porc_desc in number) is
  
    v_user      varchar2(30) := gen_user;
    v_codi_alte number;
    v_clpr_desc varchar2(300);
    v_cant      number;
    v_cant_2    number;
  begin
  
    if p_fech_desd is null then
      raise_application_error(-20001,
                              'La fecha desde no puede quedar vacia');
    end if;
    if p_fech_hast is null then
      raise_application_error(-20001,
                              'La fecha hasta no puede quedar vacia');
    end if;
    if p_fech_desd > p_fech_hast then
      raise_application_error(-20001,
                              'La fecha desde no puede ser mayor a la fecha hasta');
    end if;
    if p_porc_desc is null then
      raise_application_error(-20001,
                              'El porcentaje descuento no puede quedar vacio');
    end if;
  
    select count(*)
      into v_cant
      from come_desc_clie
     where decl_codi <> p_codi_come
       and decl_clpr_codi = p_clie
       and (p_fech_desd between decl_fech_desd and decl_fech_hast or
           p_fech_hast between decl_fech_desd and decl_fech_hast);
  
    if v_cant > 0 then
      raise_application_error(-20001,
                              'El cliente ya tiene asignado otro descuento en el rango de la fecha seleccionada');
    end if;
  
    select count(*)
      into v_cant_2
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_C001 = p_clie;
  
    if v_cant_2 > 0 then
      raise_application_error(-20001, 'El cliente ya esta en la lista');
    end if;
  
    select clpr_codi_alte, clpr_desc
      into v_codi_alte, v_clpr_desc
      from come_clie_prov a
     where a.clpr_codi = p_clie;
  
    insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_c001,
       taax_c002,
       taax_c003,
       taax_c004,
       taax_seq)
    values
      (V('APP_SESSION'),
       v_user,
       p_clie,
       v_codi_alte,
       v_clpr_desc,
       'N',
       seq_come_tabl_auxi.nextval);
  
  end pp_add_clie;

  procedure pp_agregar_clie_excel(p_codi_come in number,
                                  p_fech_desd in date,
                                  p_fech_hast in date,
                                  p_porc_desc in number,
                                  p_archivo   in varchar2) is
  
    cursor c_clientes is
      with files as
       (select blob_content, filename
          from apex_application_temp_files
         order by created_on desc
         fetch first 1 row only)
      select col001 cod_Cliente, col002 cod_alte, col003 cliente
        from files f
       cross join table (apex_data_parser.parse(p_content   => f.blob_content,
                               p_file_name => f.filename)) excel
       where line_number > 1;
  
    v_user     varchar2(30) := gen_user;
    v_cant     number;
    v_cant_2   number;
    v_asignado varchar2(2);
  begin
    --raise_application_error(-20001,'Debe cargar el archivo');
    if p_archivo is null then
      raise_application_error(-20001, 'Debe cargar el archivo');
    end if;
    if p_fech_desd is null then
      raise_application_error(-20001,
                              'La fecha desde no puede quedar vacia');
    end if;
    if p_fech_desd is null then
      raise_application_error(-20001,
                              'La fecha desde no puede quedar vacia');
    end if;
    if p_fech_hast is null then
      raise_application_error(-20001,
                              'La fecha hasta no puede quedar vacia');
    end if;
    if p_fech_desd > p_fech_hast then
      raise_application_error(-20001,
                              'La fecha desde no puede ser mayor a la fecha hasta');
    end if;
    if p_porc_desc is null then
      raise_application_error(-20001,
                              'El porcentaje descuento no puede quedar vacio');
    end if;
    for k in c_clientes loop
    
      select count(*)
        into v_cant
        from come_desc_clie
       where decl_codi <> nvl(p_codi_come, 0)
         and decl_clpr_codi = k.cod_Cliente
         and (p_fech_desd between decl_fech_desd and decl_fech_hast or
             p_fech_hast between decl_fech_desd and decl_fech_hast);
    
      select count(*)
        into v_cant_2
        from come_desc_clie
       where decl_codi = nvl(p_codi_come, 0)
         and decl_clpr_codi = k.cod_Cliente
         and (p_fech_desd between decl_fech_desd and decl_fech_hast or
             p_fech_hast between decl_fech_desd and decl_fech_hast);
    
      --  raise_application_error(-20001, v_cant||'/'||k.cod_Cliente||'/'||p_fech_desd||'/'||p_fech_hast);
      if v_cant > 0 then
        raise_application_error(-20001,
                                'El cliente: ' || k.cod_alte || '-' ||
                                k.cliente ||
                                ', ya tiene asignado un % descuento para esa fecha');
        --   v_asignado := 'S';
      else
        v_asignado := 'N';
      end if;
    
      if v_cant_2 <= 0 then
      
        insert into come_tabl_auxi
          (taax_sess,
           taax_user,
           taax_c001,
           taax_c002,
           taax_c003,
           taax_c004,
           taax_seq)
        values
          (V('APP_SESSION'),
           v_user,
           K.cod_Cliente,
           K.cod_alte,
           K.cliente,
           v_asignado,
           seq_come_tabl_auxi.nextval);
      end if;
    end loop;
  
  end pp_agregar_clie_excel;

  procedure pp_actualizar_cliente(p_decl_codi in number,
                                  p_porc_desc in number,
                                  p_fech_desd in date,
                                  p_fech_hast in date) is
    v_decl_codi      number;
    v_cant_situ      number;
    v_decl_fech_grab date;
    v_decl_user_grab varchar2(60);
    v_user           varchar2(60) := gen_user;
    v_cant_regi      number;
  begin
  
    if p_fech_desd is null then
      raise_application_error(-20001,
                              'La fecha desde no puede quedar vacia');
    end if;
    if p_fech_hast is null then
      raise_application_error(-20001,
                              'La fecha hasta no puede quedar vacia');
    end if;
    if p_fech_desd > p_fech_hast then
      raise_application_error(-20001,
                              'La fecha desde no puede ser mayor a la fecha hasta');
    end if;
    if p_porc_desc is null then
      raise_application_error(-20001,
                              'El porcentaje descuento no puede quedar vacio');
    end if;
  
    select count(taax_sess)
      into v_cant_regi
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and NVL(taax_c010, 'S') = 'S'
       and NVL(taax_c004, 'N') = 'N';
  
    if v_cant_regi <= 0 then
      raise_application_error(-20001,
                              'Debe elegir por lo menos un cliente');
    end if;
    --raise_application_error(-20001, p_decl_codi);
    if p_decl_codi is null then
      select nvl(max(decl_codi), 0) + 1
        into v_decl_codi
        from come_desc_clie;
    
      for x in (select taax_sess,
                       taax_user,
                       taax_c001 Codigo,
                       taax_c002 Cod_Alte,
                       taax_c003 Cliente
                  from come_tabl_auxi
                 where taax_sess = v('APP_SESSION')
                   and NVL(taax_c010, 'S') = 'S'
                   and NVL(taax_c004, 'S') = 'N') loop
      
        insert into come_desc_clie
          (decl_codi,
           decl_porc_desc,
           decl_fech_desd,
           decl_fech_hast,
           decl_clpr_codi,
           decl_fech_grab,
           decl_user_grab)
        values
          (v_decl_codi,
           p_porc_desc,
           p_fech_desd,
           p_fech_hast,
           x.Codigo,
           sysdate,
           v_user);
      end loop;
    
    else
      select decl_fech_grab, decl_user_grab
        into v_decl_fech_grab, v_decl_user_grab
        from come_desc_clie
       where decl_codi = p_decl_codi
       group by decl_fech_grab, decl_user_grab;
    
      delete come_desc_clie where decl_codi = p_decl_codi;
    
      for x in (select taax_sess,
                       taax_user,
                       taax_c001 Codigo,
                       taax_c002 Cod_Alte,
                       taax_c003 Cliente
                  from come_tabl_auxi
                 where taax_sess = v('APP_SESSION')
                   and NVL(taax_c010, 'S') = 'S'
                   and NVL(taax_c004, 'S') = 'N') loop
      
        insert into come_desc_clie
          (decl_codi,
           decl_porc_desc,
           decl_fech_desd,
           decl_fech_hast,
           decl_clpr_codi,
           decl_fech_grab,
           decl_fech_modi,
           decl_user_grab,
           decl_user_modi)
        values
          (p_decl_codi,
           p_porc_desc,
           p_fech_desd,
           p_fech_hast,
           x.Codigo,
           v_decl_fech_grab,
           sysdate,
           v_decl_user_grab,
           v_user);
      
      end loop;
    end if;
    delete come_tabl_auxi where taax_sess = v('APP_SESSION');
  end pp_actualizar_cliente;

  procedure pp_borrar_decl(p_desi_codi in number) is
  
  begin
  
    delete come_desc_clie where decl_codi = p_desi_codi;
    delete come_tabl_auxi where taax_sess = v('APP_SESSION');
  end pp_borrar_decl;

  procedure pp_inicializar(p_decl_codi in number) is
    v_user varchar2(60) := gen_user;
  begin
  
    -- delete come_tabl_auxi where taax_sess = v('APP_SESSION');
  
    for k in (select t.decl_clpr_codi, clpr_codi_alte, clpr_desc
                from come_desc_clie t, come_clie_prov
               where decl_clpr_codi = clpr_codi
                 and decl_codi = p_decl_codi) loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_seq)
      values
        (V('APP_SESSION'),
         v_user,
         K.decl_clpr_codi,
         K.clpr_codi_alte,
         K.clpr_desc,
         'N',
         seq_come_tabl_auxi.nextval);
    
    end loop;
  
  end pp_inicializar;

  procedure pp_porc_descuento(p_cliente   in number,
                             p_movi_codi in number,
                             p_impo_desc out number,
                             p_porc_desc out number,
                             p_indi_desc out varchar2) is
 
   v_situacion number;
   v_desc_situ number;
   v_desc_clie number;
   -- p_cliente number := 10063199101;
   v_descuento     number;
   v_fech_ingr     date;--varchar2(60);
   v_fech_desd     date;
   v_desc_clie_new number;
   v_vencidas      number;
   v_total_cuot    number;
 begin
 
   dbms_output.put_line('liz paso 105' || p_cliente);
 
   begin
   
     select a.clpr_cli_situ_codi, max(SOSE_FECH_EMIS)---max(s.SOSE_FECH_EMIS)
       into v_situacion, v_fech_ingr
       from come_clie_prov a, come_soli_serv s
      where clpr_codi = s.sose_clpr_codi
        and clpr_codi = p_cliente
      group by a.clpr_cli_situ_codi;
   
   exception
     when others then
       v_situacion := null;
     
   end;
 
   if v_situacion is not null and v_fech_ingr >= v_fech_desd then
   
     -----------------------------revisamos el descuento la situacion
     begin
       select s.desi_situ_proc
         into v_desc_situ
         from COME_DESC_SITU s
        where desi_situ_codi = v_situacion
          and (trunc(sysdate) between desi_fech_desd and desi_fech_hast or
              trunc(sysdate) between desi_fech_desd and desi_fech_hast);
     exception
       when others then
         v_desc_situ := 0;
     end;
   
   end if;
 
   ----------------------------revisamos el descuento por cliente 
   begin
     select r.decl_porc_desc
       into v_desc_clie
       from come_desc_clie r
      where decl_clpr_codi = p_cliente
        and (trunc(sysdate) between decl_fech_desd and decl_fech_hast or
            trunc(sysdate) between decl_fech_desd and decl_fech_hast);
   exception
     when others then
       v_desc_clie := 0;
   end;
   dbms_output.put_line('liz paso 106' || p_cliente);
 
   --------------------------------------revisamos si el esta en el rango de los nuevos 
   begin
     select a.decl_proc_desc porcentaje
       into v_desc_clie_new
       from come_desc_nuev_clie a
      where a.decl_situ_codi = v_situacion
        and v_fech_ingr >= a.decl_fech_desde
        and v_fech_ingr between decl_fech_cont and decl_fech_cont_hast
        and trunc(sysdate) between decl_fech_desde and
            nvl(DECL_FECH_HASTA, trunc(sysdate));
   exception
     when others then
       v_desc_clie_new := 0;
   end;
   v_vencidas := fa_devu_dias_atra_clie(p_cliente);
 
   if v_desc_clie_new > 0 and v_desc_clie <= 0 and
      to_number(to_char(sysdate, 'DD')) <= 5 and v_vencidas <= 0 then
     p_porc_desc := v_desc_clie_new;
     p_indi_desc := 'S';
   
   elsif v_desc_clie > 0 then
     p_porc_desc := v_desc_clie;
     p_indi_desc := 'S';
   
   elsif v_desc_clie <= 0 and v_desc_situ > 0 then
     p_porc_desc := v_desc_situ;
     p_indi_desc := 'S';
   else
     p_porc_desc := 0;
     p_indi_desc := 'N';
   end if;
 
   ------------------------esta parte defino si va a tener o no descuento dependiento del monto de la cuota
 
   select nvl(sum(anpl_impo_mone), 0)
     into v_total_cuot
     from come_soli_serv_anex_plan a, come_soli_serv_anex_Deta e
    where a.anpl_deta_codi = e.deta_codi
      and a.anpl_movi_codi = p_movi_codi
      and (a.anpl_impo_mone >= 90000 or (e.deta_Conc_codi = 239 and a.anpl_impo_mone >= 35000 ));
 
   if v_total_cuot > 0 and p_indi_desc = 'S' then
     p_impo_desc := round((v_total_cuot * p_porc_desc) / 100);  
     p_indi_desc := 'S';
     p_porc_desc := p_porc_desc;
   else
     p_impo_desc := 0;
     p_indi_desc := 'N';
     p_porc_desc := 0;
   end if;
   

 
   dbms_output.put_line('Descuento final: ' || p_porc_desc);
 
 end pp_porc_descuento;

  procedure pp_mostrar_impu(p_cuot_impu_codi           in number,
                            p_impu_porc                out number,
                            p_impu_porc_base_impo      out number,
                            p_impu_indi_baim_impu_incl out number) is
  begin
  
    select impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S')
      into p_impu_porc, p_impu_porc_base_impo, p_impu_indi_baim_impu_incl
      from come_impu
     where impu_codi = p_cuot_impu_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Impuesto inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20001, 'When others...' || sqlerrm);
  end pp_mostrar_impu;

  procedure pp_busca_movi_nume(p_movi_codi                in number,
                               p_movi_nume                out number,
                               p_movi_timo_codi           out number,
                               p_movi_mone_codi           out number,
                               p_movi_clpr_codi           out number,
                               p_sucu_nume_item           out number,
                               p_total                    out number,
                               p_movi_fech_emis           out date,
                               p_movi_sucu_codi_orig      out number,
                               p_movi_tasa_mone           out number,
                               p_movi_sald_mone           out number,
                               p_cuot_impu_codi           out number,
                               p_impu_porc                out number,
                               p_impu_porc_base_impo      out number,
                               p_impu_indi_baim_impu_incl out number,
                               p_clpr_Desc                out varchar2,
                               p_movi_empr_codi           out varchar2,
                               p_movi_codi_fact           out number) is
    v_sucu_nume_item number;
    v_ind_movi_codi  varchar2(10);
  begin
  
    begin
      select sum(cuot_impo_mone) total,
             movi_fech_emis,
             movi_sucu_codi_orig,
             movi_tasa_mone,
             movi_clpr_sucu_nume_item,
             sum(cuot_sald_mone) movi_sald_mone,
             cuot_impu_codi,
             movi_clpr_codi,
             clpr_Desc,
             movi_mone_codi,
             movi_empr_codi,
             movi_nume,
             movi_timo_codi,
             movi_codi_padr
        into p_total,
             p_movi_fech_emis,
             p_movi_sucu_codi_orig,
             p_movi_tasa_mone,
             v_sucu_nume_item,
             p_movi_sald_mone,
             p_cuot_impu_codi,
             p_movi_clpr_codi,
             p_clpr_Desc,
             p_movi_mone_codi,
             p_movi_empr_codi,
             p_movi_nume,
             p_movi_timo_codi,
             p_movi_codi_fact
        from come_movi, come_movi_cuot, come_clie_prov
       where movi_codi = cuot_movi_codi
         and movi_clpr_Codi = clpr_codi
         and movi_codi = p_movi_codi
       group by movi_fech_emis,
                movi_sucu_codi_orig,
                movi_tasa_mone,
                movi_clpr_sucu_nume_item,
                cuot_impu_codi,
                movi_clpr_codi,
                clpr_Desc,
                movi_mone_codi,
                movi_empr_codi,
                movi_nume,
                movi_timo_codi,
                movi_codi_padr;
    
      if p_sucu_nume_item = 0 then
        if v_sucu_nume_item is not null then
          p_movi_nume := null;
          raise_application_error(-20001,
                                  'El documento seleccionado pertenece a una Subcuenta');
        end if;
      elsif nvl(p_sucu_nume_item, 0) <> 0 then
        if v_sucu_nume_item <> p_sucu_nume_item then
          p_movi_nume := null;
          raise_application_error(-20001,
                                  'El documento seleccionado pertenece a una Subcuenta distinta a la seleccionada');
        end if;
      end if;
    
      if p_cuot_impu_codi is not null then
        pp_mostrar_impu(p_cuot_impu_codi,
                        p_impu_porc,
                        p_impu_porc_base_impo,
                        p_impu_indi_baim_impu_incl);
      end if;
    
    exception
      when no_data_found then
        raise_application_error(-20001, 'Numero de Movimiento inexistente');
      
    end;
  
    if p_movi_sald_mone <= 0 then
      raise_application_error(-20001, 'El Movimiento no posee saldo..');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Movimiento Inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Nro. de Movimiento Duplicado');
    when others then
      raise_application_error(-20001,
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' ||
                              sqlerrm);
  end pp_busca_movi_nume;
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

  procedure pp_insert_come_movi_cuot_canc(p_canc_movi_codi      in number,
                                          p_canc_cuot_movi_codi in number,
                                          p_canc_cuot_fech_venc in date,
                                          p_canc_fech_pago      in date,
                                          p_canc_impo_mone      in number,
                                          p_canc_impo_mmnn      in number,
                                          p_canc_impo_mmee      in number,
                                          p_canc_impo_dife_camb in number,
                                          p_canc_impo_rete_mone in number,
                                          p_canc_impo_rete_mmnn in number,
                                          p_canc_tipo           in varchar2) is
  begin
    insert into come_movi_cuot_canc
      (canc_movi_codi,
       canc_cuot_movi_codi,
       canc_cuot_fech_venc,
       canc_fech_pago,
       canc_impo_mone,
       canc_impo_mmnn,
       canc_impo_mmee,
       canc_impo_dife_camb,
       canc_impo_rete_mone,
       canc_impo_rete_mmnn,
       canc_base,
       canc_tipo,
       canc_indi_afec_sald)
    values
      (p_canc_movi_codi,
       p_canc_cuot_movi_codi,
       p_canc_cuot_fech_venc,
       p_canc_fech_pago,
       p_canc_impo_mone,
       p_canc_impo_mmnn,
       p_canc_impo_mmee,
       p_canc_impo_dife_camb,
       p_canc_impo_rete_mone,
       p_canc_impo_rete_mmnn,
       1, --parameter.p_codi_base  ,
       p_canc_tipo,
       'S');
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_insert_come_movi_cuot_canc;

  procedure pp_insertar_interes(p_factura_codi in number,
                                p_impo_pago    in number) is
  
    --cursor del detalle de la factura(se le pasa el codigo de la factura) 
    cursor c_fact_deta is
      select deta_movi_codi,
             deta_nume_item,
             d.deta_impo_mone,
             d.deta_impo_mmnn
        from come_movi_prod_deta d
       where d.deta_movi_codi = p_factura_codi;
  
    v_impo_inte_mmnn      number;
    v_impo_inte_mone      number;
    v_porc_inte_apli      number;
    v_porc_inte_item      number;
    v_inte_apli_mmnn      number;
    v_inte_apli_mone      number;
    v_apli_movi_codi      number;
    v_apli_movi_codi_adel number;
  
    v_impo_pago      number;
    v_tota_fact_mone number;
  
  begin
  
    select sum(deta_impo_mone)
      into v_tota_fact_mone
      from come_movi_prod_deta
     where deta_movi_codi = p_factura_codi;
  
    v_apli_movi_codi_adel := bcab.movi_codi;
    v_apli_movi_codi      := bcab.movi_codi_apli; -- g_come_movi.movi_codi_apli;
    v_impo_pago           := p_impo_pago;
  
    v_porc_inte_apli := (v_impo_pago * 100) / bcab.s_total; --porcentaje de interes de la aplicacion con respecto al interes del adelanto
    v_inte_apli_mone := round(((v_porc_inte_apli * bcab.movi_impo_inte_mone) / 100),
                              4); --importe de interes de la aplicacion 
    v_inte_apli_mmnn := round(((v_porc_inte_apli * bcab.movi_impo_inte_mmnn) / 100),
                              4); --importe de interes de la aplicacion mmnn
    for z in c_fact_deta loop
    
      v_porc_inte_item := (z.deta_impo_mone * 100) / v_tota_fact_mone; --porcentaje a aplicar del interes por item
      v_impo_inte_mmnn := round(((v_inte_apli_mmnn * v_porc_inte_item) / 100),
                                4); --importe del interes por item mmnn
      v_impo_inte_mone := round(((v_inte_apli_mone * v_porc_inte_item) / 100),
                                4); --importe del interes por item         
    
      insert into come_movi_apli_inte_comp
        (apli_movi_codi_adel,
         apli_movi_codi_comp,
         apli_nume_item_comp,
         apli_movi_codi_apli,
         apli_impo_mone,
         apli_impo_mmnn)
      values
        (v_apli_movi_codi_adel,
         z.deta_movi_codi,
         z.deta_nume_item,
         v_apli_movi_codi,
         v_impo_inte_mone,
         v_impo_inte_mmnn);
    
    end loop;
  
  end pp_insertar_interes;

  procedure pp_insert_come_movi(p_movi_codi                in number,
                                p_movi_timo_codi           in number,
                                p_movi_clpr_codi           in number,
                                p_movi_sucu_codi_orig      in number,
                                p_movi_depo_codi_orig      in number,
                                p_movi_sucu_codi_dest      in number,
                                p_movi_depo_codi_dest      in number,
                                p_movi_oper_codi           in number,
                                p_movi_cuen_codi           in number,
                                p_movi_mone_codi           in number,
                                p_movi_nume                in number,
                                p_movi_fech_emis           in date,
                                p_movi_fech_grab           in date,
                                p_movi_user                in varchar2,
                                p_movi_codi_padr           in number,
                                p_movi_tasa_mone           in number,
                                p_movi_tasa_mmee           in number,
                                p_movi_grav_mmnn           in number,
                                p_movi_exen_mmnn           in number,
                                p_movi_iva_mmnn            in number,
                                p_movi_grav_mmee           in number,
                                p_movi_exen_mmee           in number,
                                p_movi_iva_mmee            in number,
                                p_movi_grav_mone           in number,
                                p_movi_exen_mone           in number,
                                p_movi_iva_mone            in number,
                                p_movi_obse                in varchar2,
                                p_movi_sald_mmnn           in number,
                                p_movi_sald_mmee           in number,
                                p_movi_sald_mone           in number,
                                p_movi_stoc_suma_rest      in varchar2,
                                p_movi_clpr_dire           in varchar2,
                                p_movi_clpr_tele           in varchar2,
                                p_movi_clpr_ruc            in varchar2,
                                p_movi_clpr_desc           in varchar2,
                                p_movi_emit_reci           in varchar2,
                                p_movi_afec_sald           in varchar2,
                                p_movi_dbcr                in varchar2,
                                p_movi_stoc_afec_cost_prom in varchar2,
                                p_movi_empr_codi           in number,
                                p_movi_clave_orig          in number,
                                p_movi_clave_orig_padr     in number,
                                p_movi_indi_iva_incl       in varchar2,
                                p_movi_empl_codi           in number,
                                p_movi_nume_timb           in varchar2,
                                p_movi_fech_venc_timb      in date,
                                p_movi_fech_oper           in date,
                                p_movi_excl_cont           in varchar2,
                                p_movi_clpr_sucu_nume_item in number) is
  begin
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_depo_codi_orig,
       movi_sucu_codi_dest,
       movi_depo_codi_dest,
       movi_oper_codi,
       movi_cuen_codi,
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
       movi_obse,
       movi_sald_mmnn,
       movi_sald_mmee,
       movi_sald_mone,
       movi_stoc_suma_rest,
       movi_clpr_dire,
       movi_clpr_tele,
       movi_clpr_ruc,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_stoc_afec_cost_prom,
       movi_empr_codi,
       movi_clave_orig,
       movi_clave_orig_padr,
       movi_indi_iva_incl,
       movi_empl_codi,
       movi_base,
       movi_fech_oper,
       movi_excl_cont,
       movi_clpr_sucu_nume_item)
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_depo_codi_orig,
       p_movi_sucu_codi_dest,
       p_movi_depo_codi_dest,
       p_movi_oper_codi,
       p_movi_cuen_codi,
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
       p_movi_obse,
       p_movi_sald_mmnn,
       p_movi_sald_mmee,
       p_movi_sald_mone,
       p_movi_stoc_suma_rest,
       p_movi_clpr_dire,
       p_movi_clpr_tele,
       p_movi_clpr_ruc,
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_stoc_afec_cost_prom,
       p_movi_empr_codi,
       p_movi_clave_orig,
       p_movi_clave_orig_padr,
       p_movi_indi_iva_incl,
       p_movi_empl_codi,
       1, -- parameter.p_codi_base            ,
       p_movi_fech_oper,
       p_movi_excl_cont,
       p_movi_clpr_sucu_nume_item);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi;

  procedure pp_insert_movi_cuot_canc_adnc(p_canc_movi_codi      in number,
                                          p_canc_cuot_movi_codi in number,
                                          p_canc_cuot_fech_venc in date,
                                          p_canc_fech_pago      in date,
                                          p_canc_impo_mone      in number,
                                          p_canc_impo_mmnn      in number,
                                          p_canc_impo_mmee      in number,
                                          p_canc_impo_dife_camb in number,
                                          p_canc_impo_rete_mone in number,
                                          p_canc_impo_rete_mmnn in number,
                                          p_canc_tipo           in varchar2,
                                          p_canc_impu_codi      in number,
                                          p_canc_impu_mone      in number,
                                          p_canc_impu_mmnn      in number,
                                          p_canc_grav10_ii_mone in number,
                                          p_canc_grav5_ii_mone  in number,
                                          p_canc_grav10_mone    in number,
                                          p_canc_grav5_mone     in number,
                                          p_canc_iva10_mone     in number,
                                          p_canc_iva5_mone      in number,
                                          p_canc_exen_mone      in number,
                                          p_canc_grav10_ii_mmnn in number,
                                          p_canc_grav5_ii_mmnn  in number,
                                          p_canc_grav10_mmnn    in number,
                                          p_canc_grav5_mmnn     in number,
                                          p_canc_iva10_mmnn     in number,
                                          p_canc_iva5_mmnn      in number,
                                          p_canc_exen_mmnn      in number) is
  
    sin_saldo exception;
    pragma exception_init(sin_saldo, -20009);
  begin
    /*
      message(p_canc_movi_codi        );     
      message(p_canc_cuot_movi_codi   ); 
      message(p_canc_cuot_fech_venc   ); 
      message(p_canc_fech_pago        ); 
      message(p_canc_impo_mone        ); 
      message(p_canc_impo_mmnn        ); 
      message(p_canc_impo_mmee        );
      message(p_canc_impo_dife_camb   );
      message(p_canc_impo_rete_mone   );
      message(p_canc_impo_rete_mmnn   );
      message(:parameter.p_codi_base  );
      message(p_canc_tipo             );
      message(p_canc_impu_codi        );
      message(p_canc_impu_mone);
      message(p_canc_impu_mmnn);
      message(p_canc_grav10_ii_mone);
      message(p_canc_grav5_ii_mone);
      message(p_canc_grav10_mone);
      message(p_canc_grav5_mone);
      message(p_canc_iva10_mone);
      message(p_canc_iva5_mone);
      message(p_canc_exen_mone);
      message(p_canc_grav10_ii_mmnn);
      message(p_canc_grav5_ii_mmnn);
      message(p_canc_grav10_mmnn);
      message(p_canc_grav5_mmnn);
      message(p_canc_iva10_mmnn);
      message(p_canc_iva5_mmnn);
      message(p_canc_exen_mmnn);
    */
    --raise_application_error(-20001,'auu '||p_canc_cuot_movi_codi||' '||p_canc_cuot_fech_venc||' '||p_canc_tipo);
    insert into come_movi_cuot_canc
      (canc_movi_codi,
       canc_cuot_movi_codi,
       canc_cuot_fech_venc,
       canc_fech_pago,
       canc_impo_mone,
       canc_impo_mmnn,
       canc_impo_mmee,
       canc_impo_dife_camb,
       canc_impo_rete_mone,
       canc_impo_rete_mmnn,
       canc_base,
       canc_tipo,
       canc_impu_codi,
       canc_impu_mone,
       canc_impu_mmnn,
       canc_grav10_ii_mone,
       canc_grav5_ii_mone,
       canc_grav10_mone,
       canc_grav5_mone,
       canc_iva10_mone,
       canc_iva5_mone,
       canc_exen_mone,
       canc_grav10_ii_mmnn,
       canc_grav5_ii_mmnn,
       canc_grav10_mmnn,
       canc_grav5_mmnn,
       canc_iva10_mmnn,
       canc_iva5_mmnn,
       canc_exen_mmnn,
       canc_indi_afec_sald)
    values
      (p_canc_movi_codi,
       p_canc_cuot_movi_codi,
       p_canc_cuot_fech_venc,
       p_canc_fech_pago,
       p_canc_impo_mone,
       p_canc_impo_mmnn,
       p_canc_impo_mmee,
       p_canc_impo_dife_camb,
       p_canc_impo_rete_mone,
       p_canc_impo_rete_mmnn,
       1, --:parameter.p_codi_base  ,
       p_canc_tipo,
       p_canc_impu_codi,
       p_canc_impu_mone,
       p_canc_impu_mmnn,
       p_canc_grav10_ii_mone,
       p_canc_grav5_ii_mone,
       p_canc_grav10_mone,
       p_canc_grav5_mone,
       p_canc_iva10_mone,
       p_canc_iva5_mone,
       p_canc_exen_mone,
       p_canc_grav10_ii_mmnn,
       p_canc_grav5_ii_mmnn,
       p_canc_grav10_mmnn,
       p_canc_grav5_mmnn,
       p_canc_iva10_mmnn,
       p_canc_iva5_mmnn,
       p_canc_exen_mmnn,
       'S');
  
  exception
    when sin_saldo then
      pl_me('El Movimiento no posee saldo...');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_desc      out varchar2,
                                      p_timo_desc_abre out varchar2,
                                      p_timo_afec_sald out varchar2,
                                      p_timo_dbcr      out varchar2,
                                      p_timo_indi_adel out varchar2,
                                      p_timo_indi_ncr  out varchar2,
                                      p_indi_vali      in varchar2) is
  
    v_dbcr varchar2(1);
  begin
  
    select timo_desc,
           timo_desc_abre,
           timo_afec_sald,
           timo_dbcr,
           nvl(timo_indi_adel, 'N'),
           nvl(timo_indi_ncr, 'N')
      into p_timo_desc,
           p_timo_desc_abre,
           p_timo_afec_sald,
           p_timo_dbcr,
           p_timo_indi_adel,
           p_timo_indi_ncr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
    if p_indi_vali = 'S' then
      if p_timo_indi_adel = 'N' and p_timo_indi_ncr = 'N' then
        raise_application_error(-20001,
                                'Solo se pueden ingresar movimientos del tipo Adelantos/Notas de Creditos');
      end if;
    
      if p_timo_indi_adel = 'S' and p_timo_indi_ncr = 'S' then
        raise_application_error(-20001,
                                'El tipo de movimiento esta configurado como Adelanto y Nota de Credito al mismo tiempo, Favor Verificar..');
      end if;
    end if;
    if parameter.p_emit_reci = 'R' then
      v_dbcr := 'D';
    else
      v_dbcr := 'C';
    end if;
  
    if p_indi_vali = 'S' then
      if p_timo_dbcr <> v_dbcr then
        raise_application_error(-20001, 'Tipo de Movimiento incorrecto');
      end if;
    end if;
  
    if nvl(p_timo_indi_adel, 'N') = 'N' then
      --set_item_property('bcab.s_calc_rete', enabled, property_false);
      bcab.calc_rete := 'N';
    end if;
  
  exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      p_timo_indi_adel := null;
      p_timo_indi_ncr  := null;
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_tipo_movi;

  procedure pp_set_variable(p_movi_codi in number) is
    v_movi_timo_desc varchar2(100);
    v_timo_Desc_abre varchar2(100);
    v_timo_afec_sald varchar2(100);
    v_timo_dbcr      varchar2(100);
    v_indi_vali      varchar2(100);
    v_movi_sald_mone number;
    v_movi_timo_codi number;
    v_sucu_nume_item number;
  begin
  
    bcab.movi_codi := p_movi_codi;
  
    --  bcab.movi_tico_codi := v('p105_movi_tico_codi'); 
  
    pp_busca_movi_nume(p_movi_codi                => bcab.movi_codi,
                       p_movi_nume                => bcab.movi_nume,
                       p_movi_timo_codi           => v_movi_timo_codi,
                       p_movi_mone_codi           => bcab.movi_mone_codi,
                       p_movi_clpr_codi           => bcab.movi_clpr_codi,
                       p_sucu_nume_item           => v_sucu_nume_item,
                       p_total                    => bcab.s_total,
                       p_movi_fech_emis           => bcab.movi_fech_emis,
                       p_movi_sucu_codi_orig      => bcab.movi_sucu_codi_orig,
                       p_movi_tasa_mone           => bcab.movi_tasa_mone,
                       p_movi_sald_mone           => v_movi_sald_mone,
                       p_cuot_impu_codi           => bcab.cuot_impu_codi,
                       p_impu_porc                => bcab.impu_porc,
                       p_impu_porc_base_impo      => bcab.impu_porc_base_impo,
                       p_impu_indi_baim_impu_incl => bcab.impu_indi_baim_impu_incl,
                       p_clpr_Desc                => bcab.movi_clpr_desc,
                       p_movi_empr_codi           => bcab.movi_empr_codi,
                       p_movi_codi_fact           => bcab.movi_codi_fact);
  
    I020017.pp_muestra_come_tipo_movi(p_timo_codi      => v_movi_timo_codi,
                                      p_timo_Desc      => v_movi_timo_desc,
                                      p_timo_Desc_abre => v_timo_Desc_abre,
                                      p_timo_afec_sald => v_timo_afec_sald,
                                      p_timo_dbcr      => v_timo_dbcr,
                                      p_timo_indi_adel => bcab.movi_timo_indi_adel,
                                      p_timo_indi_ncr  => bcab.movi_timo_indi_ncr,
                                      p_indi_vali      => v_indi_vali);
  
    select j.mone_cant_deci
      into bcab.movi_mone_cant_deci
      from come_mone j
     where j.mone_codi = bcab.movi_mone_codi;
  
    bcab.movi_fech_apli := trunc(sysdate);
    bcab.s_dife         := 0;
    bcab.p_para_inic    := 'C';
  
    bcab.sum_impo_pago      := bcab.s_total;
    bcab.sum_impo_rete_mone := 0;
  end pp_set_variable;

  procedure pp_actualiza_canc(p_movi_codi_nc in number) is
  
    salir exception;
    --insertar los recibos de cancelaciones
    --Cancelacion de la NC/Adel..................
    --Cancelacion de la Factura/Nota de Debito....
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_timo_desc      varchar2(60);
    v_movi_timo_desc_abre varchar2(10);
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
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
  
    v_movi_depo_codi_orig number;
    v_movi_sucu_codi_dest number;
    v_movi_depo_codi_dest number;
    v_movi_oper_codi      number;
    v_movi_cuen_codi      number;
    v_movi_obse           varchar2(2000);
  
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(80);
    v_movi_clpr_tele           varchar2(80);
    v_movi_clpr_ruc            varchar2(80);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_nume_timb           number;
    v_movi_fech_venc_timb      date;
    v_movi_fech_oper           date;
    v_movi_excl_cont           varchar2(1);
    v_movi_clpr_sucu_nume_item number;
  
    --variables para come_movi_cuot_canc...
    v_canc_movi_codi      number;
    v_canc_cuot_movi_codi number;
    v_canc_cuot_fech_venc date;
    v_canc_fech_pago      date;
    v_canc_impo_mone      number;
    v_canc_impo_mmnn      number;
    v_canc_impo_mmee      number;
    v_canc_impo_dife_camb number := 0;
    v_canc_impo_rete_mone number := 0;
    v_canc_impo_rete_mmnn number := 0;
    v_canc_tipo           varchar2(2);
    v_canc_impu_codi      number;
  
    v_canc_impo_mone_ii number(20, 4);
    v_canc_impo_mmnn_ii number(20, 4);
    v_canc_impu_mone    number(20, 4);
    v_canc_impu_mmnn    number(20, 4);
  
    v_canc_grav10_ii_mone number(20, 4);
    v_canc_grav5_ii_mone  number(20, 4);
    v_canc_exen_mone      number(20, 4);
    v_canc_iva10_mone     number(20, 4);
    v_canc_iva5_mone      number(20, 4);
    v_canc_grav10_ii_mmnn number(20, 4);
    v_canc_grav5_ii_mmnn  number(20, 4);
    v_canc_exen_mmnn      number(20, 4);
    v_canc_iva10_mmnn     number(20, 4);
    v_canc_iva5_mmnn      number(20, 4);
    v_canc_grav10_mone    number(20, 4);
    v_canc_grav5_mone     number(20, 4);
    v_canc_grav10_mmnn    number(20, 4);
    v_canc_grav5_mmnn     number(20, 4);
  
    cursor c_movi_cuot(p_movi_codi in number) is
      select cuot_movi_codi, cuot_fech_venc, cuot_sald_mone
        from come_movi_cuot
       where cuot_movi_codi = p_movi_codi
         and cuot_sald_mone > 0;
  
    v_impo_canc number;
    v_impo_deto number;
  
    v_indi_adel char(1);
    v_indi_ncr  char(1);
  
    cursor detalle is
      select 'X' ind_marcado,
             movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             movi_codi cuot_movi_codi,
             movi_tasa_mone cuot_tasa_mone,
             timo_desc,
             timo_desc_abre,
             cuot_tipo,
             movi_mone_codi,
             bcab.s_total impo_pago,
             null impo_rete_mone,
             null S_IMPO_PAGO_ADEL,
             null apli_rete,
             null v_impo_pago_mmnn
        from come_movi, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_codi = bcab.movi_codi_fact
         and timo_codi = movi_timo_codi
         and cuot_sald_mone > 0
       order by cuot_fech_venc, movi_fech_emis, movi_nume;
  
  begin
  
    pp_set_variable(p_movi_codi_nc);
    --  |------------------------------------------------------------|
    --  |-Insertar la cancelacion de la nota de Credito/o adelanto...|
    --  |------------------------------------------------------------|  
  
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido y luego si es una nota de credito o un adelanto....
    if parameter.p_emit_reci = 'E' then
    
      --es emitido
      if bcab.movi_timo_indi_adel = 'S' and bcab.movi_timo_indi_ncr = 'N' then
        --si es un adelanto
        v_movi_timo_codi := parameter.p_codi_timo_rcnadle;
      elsif bcab.movi_timo_indi_adel = 'N' and
            bcab.movi_timo_indi_ncr = 'S' then
        --si es una Nota de Credito
        v_movi_timo_codi := parameter.p_codi_timo_cnncre;
      end if;
    else
      --si es Recibido..
      if bcab.movi_timo_indi_adel = 'S' and bcab.movi_timo_indi_ncr = 'N' then
        --si es un adelanto
        v_movi_timo_codi := parameter.p_codi_timo_rcnadlr;
      elsif bcab.movi_timo_indi_adel = 'N' and
            bcab.movi_timo_indi_ncr = 'S' then
        --si es una Nota de Credito
        v_movi_timo_codi := parameter.p_codi_timo_cnncrr;
      end if;
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    v_movi_codi           := fa_sec_come_movi;
    bcab.movi_codi_apli   := v_movi_codi;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_fech_emis      := bcab.movi_fech_apli;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := round(((bcab.sum_impo_pago -
                                   nvl(bcab.sum_impo_rete_mone, 0)) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := nvl(bcab.sum_impo_pago, 0) -
                             nvl(bcab.sum_impo_rete_mone, 0);
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := bcab.movi_clpr_desc;
    v_movi_emit_reci      := parameter.p_emit_reci;
    v_movi_empr_codi      := bcab.movi_empr_codi;
  
    v_movi_depo_codi_orig      := null;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_depo_codi_orig,
                        v_movi_sucu_codi_dest,
                        v_movi_depo_codi_dest,
                        v_movi_oper_codi,
                        v_movi_cuen_codi,
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
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_stoc_suma_rest,
                        v_movi_clpr_dire,
                        v_movi_clpr_tele,
                        v_movi_clpr_ruc,
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_stoc_afec_cost_prom,
                        v_movi_empr_codi,
                        v_movi_clave_orig,
                        v_movi_clave_orig_padr,
                        v_movi_indi_iva_incl,
                        v_movi_empl_codi,
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_fech_oper,
                        v_movi_excl_cont,
                        v_movi_clpr_sucu_nume_item);
  
    --Obse. Los Adelantos y notas de creditos tendr?n siempre una sola cuota..
    --con fecha de vencimiento igual a la fecha del documento.................
  
    --------
    v_canc_impo_mone_ii := nvl(bcab.sum_impo_pago, 0) -
                           nvl(bcab.sum_impo_rete_mone, 0);
    v_canc_impo_mmnn_ii := round((v_canc_impo_mone_ii * bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
  
    pa_devu_impo_calc(v_canc_impo_mone_ii,
                      bcab.movi_mone_cant_deci,
                      bcab.impu_porc,
                      bcab.impu_porc_base_impo,
                      bcab.impu_indi_baim_impu_incl,
                      v_canc_impo_mone_ii,
                      v_canc_grav10_ii_mone,
                      v_canc_grav5_ii_mone,
                      v_canc_grav10_mone,
                      v_canc_grav5_mone,
                      v_canc_iva10_mone,
                      v_canc_iva5_mone,
                      v_canc_exen_mone);
  
    pa_devu_impo_calc(v_canc_impo_mmnn_ii,
                      parameter.p_cant_deci_mmnn,
                      bcab.impu_porc,
                      bcab.impu_porc_base_impo,
                      bcab.impu_indi_baim_impu_incl,
                      v_canc_impo_mmnn_ii,
                      v_canc_grav10_ii_mmnn,
                      v_canc_grav5_ii_mmnn,
                      v_canc_grav10_mmnn,
                      v_canc_grav5_mmnn,
                      v_canc_iva10_mmnn,
                      v_canc_iva5_mmnn,
                      v_canc_exen_mmnn);
  
    --v_canc_impo_mmnn := v_canc_exen_mmnn + v_canc_grav10_mmnn + v_canc_grav5_mmnn;
    --v_canc_impo_mone := v_canc_exen_mone + v_canc_grav10_mone + v_canc_grav5_mone;
    v_canc_impu_mone := v_canc_iva10_mone + v_canc_iva5_mone;
    v_canc_impu_mmnn := v_canc_iva10_mmnn + v_canc_iva5_mmnn;
    v_canc_impu_codi := bcab.cuot_impu_codi;
    -------------------
  
    v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de nc/adel
    v_canc_cuot_movi_codi := bcab.movi_codi; --clave de la nota de credito/ adel
    v_canc_cuot_fech_venc := bcab.movi_fech_emis; --fecha de venc. de la cuota de NC/Adel (= a la fecha de la nc/Adel)
    v_canc_fech_pago      := bcab.movi_fech_apli; --fecha de aplicacion de la cuota de NC (= a la fecha de la nc)
    v_canc_impo_mone      := v_canc_impo_mone_ii; --v_movi_exen_mone; --siempre el importe de cancelacion ser? exento...
    v_canc_impo_mmnn      := v_canc_impo_mmnn_ii; --v_movi_exen_mmnn;
    v_canc_impo_mmee      := 0; --v_movi_exen_mmee;
    v_canc_impo_dife_camb := 0;
    v_canc_impo_rete_mone := 0;
    v_canc_impo_rete_mmnn := 0;
  
    ----PRUEBAA
  
    pp_insert_movi_cuot_canc_adnc(v_canc_movi_codi,
                                  v_canc_cuot_movi_codi,
                                  v_canc_cuot_fech_venc,
                                  v_canc_fech_pago,
                                  v_canc_impo_mone,
                                  v_canc_impo_mmnn,
                                  v_canc_impo_mmee,
                                  0,
                                  0,
                                  0,
                                  'C',
                                  v_canc_impu_codi,
                                  v_canc_impu_mone,
                                  v_canc_impu_mmnn,
                                  v_canc_grav10_ii_mone,
                                  v_canc_grav5_ii_mone,
                                  v_canc_grav10_mone,
                                  v_canc_grav5_mone,
                                  v_canc_iva10_mone,
                                  v_canc_iva5_mone,
                                  v_canc_exen_mone,
                                  v_canc_grav10_ii_mmnn,
                                  v_canc_grav5_ii_mmnn,
                                  v_canc_grav10_mmnn,
                                  v_canc_grav5_mmnn,
                                  v_canc_iva10_mmnn,
                                  v_canc_iva5_mmnn,
                                  v_canc_exen_mmnn);
  
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de la nota de credito  / Adelanto...
    -----------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------
    ---insertar la cancelacion de la/s Factura/s..../ Notas de Debitos......................................................
    ------------------------------------------------------------------------------------------------------------------------
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido y luego si es una nota de credito o un adelanto....
    if parameter.p_emit_reci = 'E' then
      --es emitido
      v_movi_timo_codi := parameter.p_codi_timo_cnfcre;
    else
      --si es Recibido..
      v_movi_timo_codi := parameter.p_codi_timo_cnfcrr;
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    v_movi_codi_padr           := v_movi_codi; --clave de la cancelacion del adel/Nota de Credito
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_canc_codi_fcrr := v_movi_codi;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_apli;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := gen_user;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := 0;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round((bcab.sum_impo_pago *
                                        bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := bcab.sum_impo_pago;
    v_movi_iva_mone            := 0;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := parameter.p_emit_reci;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_depo_codi_orig,
                        v_movi_sucu_codi_dest,
                        v_movi_depo_codi_dest,
                        v_movi_oper_codi,
                        v_movi_cuen_codi,
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
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_stoc_suma_rest,
                        v_movi_clpr_dire,
                        v_movi_clpr_tele,
                        v_movi_clpr_ruc,
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_stoc_afec_cost_prom,
                        v_movi_empr_codi,
                        v_movi_clave_orig,
                        v_movi_clave_orig_padr,
                        v_movi_indi_iva_incl,
                        v_movi_empl_codi,
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_fech_oper,
                        v_movi_excl_cont,
                        v_movi_clpr_sucu_nume_item);
  
    for bdet in detalle loop
      if bdet.ind_marcado = 'X' then
      
        if nvl(bdet.impo_pago, 0) > 0 then
        
          v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de Fac
          v_canc_cuot_movi_codi := bdet.cuot_movi_codi;
          v_canc_cuot_fech_venc := bdet.cuot_fech_venc;
          v_canc_fech_pago      := bcab.movi_fech_apli; --fecha de cancelacion de la cuota de NC/adel (= a la fecha de la nc/adel)      
          v_canc_impo_mone      := bdet.impo_pago;
          v_canc_tipo           := bdet.cuot_tipo;
          v_canc_impo_mmnn      := round((bdet.impo_pago *
                                         bcab.movi_tasa_mone),
                                         0);
          v_canc_impo_mmee      := 0;
          v_canc_impo_dife_camb := round(((bcab.movi_tasa_mone -
                                         bdet.cuot_tasa_mone) *
                                         v_canc_impo_mone),
                                         0);
          v_canc_impo_rete_mone := bdet.impo_rete_mone;
          v_canc_impo_rete_mmnn := round((bdet.impo_rete_mone *
                                         nvl(bcab.movi_tasa_mone, 1)),
                                         0);
        
          pp_insert_come_movi_cuot_canc(v_canc_movi_codi,
                                        v_canc_cuot_movi_codi,
                                        v_canc_cuot_fech_venc,
                                        v_canc_fech_pago,
                                        v_canc_impo_mone,
                                        v_canc_impo_mmnn,
                                        v_canc_impo_mmee,
                                        v_canc_impo_dife_camb,
                                        v_canc_impo_rete_mone,
                                        v_canc_impo_rete_mmnn,
                                        v_canc_tipo);
        
          if bcab.movi_timo_indi_adel = 'S' and
             bcab.movi_timo_indi_ncr = 'N' then
            if bcab.movi_impo_inte_mone is not null then
              pp_insertar_interes(v_canc_cuot_movi_codi, v_canc_impo_mone);
            end if;
          end if;
        end if;
      end if;
    
    end loop;
    -- raise_application_error(-20001,'auu');
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de la/s Factura/s  
    -----------------------------------------------------------------------------------------------------------------------
  
    --    |-------------------------------------------------------------|
    --    |Obse. Los movimientos de tipo cance., no afectan caja, ni    |
    --    |tampoco tienen saldo, sirven unicamente para la aplicacion   |
    --    |conrrespondiente de los adelantos y Notas de Creditos,       |
    --    |-------------------------------------------------------------|
    /*  Exception
    
    when others then
      raise_application_error(-20001, sqlerrm);*/
  end;

  ---------------------------------genera nc
  procedure pa_gene_nota_cred(p_clave_fact   in number,
                              p_imp_ncr_in   in number,
                              p_imp_ncr_out  out number,
                              p_para_conc_in in varchar) is
  
    v_movi_fact_codi number;
  
    --variables come_movi
    v_movi_codi                number;
    v_movi_timo_codi           number;
    v_movi_clpr_codi           number;
    v_movi_sucu_codi_orig      number;
    v_movi_depo_codi_orig      number;
    v_movi_sucu_codi_dest      number;
    v_movi_depo_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_cuen_codi           number;
    v_movi_mone_codi           number;
    v_movi_nume                number;
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(250);
    v_movi_codi_padr           number;
    v_movi_tasa_mone           number;
    v_movi_tasa_mmee           number;
    v_movi_grav_mmnn           number;
    v_movi_exen_mmnn           number;
    v_movi_iva_mmnn            number;
    v_movi_grav_mmee           number;
    v_movi_exen_mmee           number;
    v_movi_iva_mmee            number;
    v_movi_grav_mone           number;
    v_movi_exen_mone           number;
    v_movi_iva_mone            number;
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(20);
    v_movi_clpr_desc           varchar2(80);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number;
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_oper           date;
    v_movi_fech_inic_timb      date;
    v_movi_fech_venc_timb      date;
    v_movi_codi_rete           number;
    v_movi_excl_cont           varchar2(1);
    v_movi_impo_mone_ii        number;
    v_movi_impo_mmnn_ii        number;
    v_movi_grav10_ii_mone      number;
    v_movi_grav5_ii_mone       number;
    v_movi_grav10_ii_mmnn      number;
    v_movi_grav5_ii_mmnn       number;
    v_movi_grav10_mone         number;
    v_movi_grav5_mone          number;
    v_movi_grav10_mmnn         number;
    v_movi_grav5_mmnn          number;
    v_movi_iva10_mone          number;
    v_movi_iva5_mone           number;
    v_movi_iva10_mmnn          number;
    v_movi_iva5_mmnn           number;
    v_movi_clpr_sucu_nume_item number;
    v_movi_indi_apli_tick      varchar2(1);
  
    --variables come_movi_conc_deta
    v_moco_movi_codi      number(20);
    v_moco_nume_item      number(10);
    v_moco_conc_codi      number(10);
    v_moco_cuco_codi      number(10);
    v_moco_impu_codi      number(10);
    v_moco_impo_mmnn      number(20, 4);
    v_moco_impo_mmee      number(20, 4);
    v_moco_impo_mone      number(20, 4);
    v_moco_dbcr           varchar2(1);
    v_moco_base           number(2);
    v_moco_desc           varchar2(2000);
    v_moco_tiim_codi      number(10);
    v_moco_indi_fact_serv varchar2(1);
    v_moco_impo_mone_ii   number(20, 4);
    v_moco_ortr_codi      number(20);
    v_moco_impo_codi      number(20);
    v_moco_cant           number(20, 4);
    v_moco_cant_pulg      number(20, 4);
    v_moco_movi_codi_padr number(20);
    v_moco_nume_item_padr number(10);
    v_moco_ceco_codi      number(20);
    v_moco_orse_codi      number(20);
    v_moco_osli_codi      number(20);
    v_moco_tran_codi      number(20);
    v_moco_bien_codi      number(20);
    v_moco_emse_codi      number(4);
    v_moco_impo_mmnn_ii   number(20, 4);
    v_moco_sofa_sose_codi number(20);
    v_moco_sofa_nume_item number(20);
    v_moco_tipo_item      varchar2(2);
    v_moco_clpr_codi      number(20);
    v_moco_prod_nume_item number(20);
    v_moco_guia_nume      number(20);
    v_moco_grav10_ii_mone number(20, 4);
    v_moco_grav5_ii_mone  number(20, 4);
    v_moco_grav10_ii_mmnn number(20, 4);
    v_moco_grav5_ii_mmnn  number(20, 4);
    v_moco_grav10_mone    number(20, 4);
    v_moco_grav5_mone     number(20, 4);
    v_moco_grav10_mmnn    number(20, 4);
    v_moco_grav5_mmnn     number(20, 4);
    v_moco_iva10_mone     number(20, 4);
    v_moco_iva5_mone      number(20, 4);
    v_moco_conc_codi_impu number(10);
    v_moco_tipo           varchar2(2);
    v_moco_prod_codi      number(20);
    v_moco_ortr_codi_fact number(20);
    v_moco_iva10_mmnn     number(20, 4);
    v_moco_iva5_mmnn      number(20, 4);
    v_moco_exen_mone      number(20, 4);
    v_moco_exen_mmnn      number(20, 4);
    v_moco_empl_codi      number(10);
    v_moco_lote_codi      number(10);
    v_moco_bene_codi      number(4);
    v_moco_medi_codi      number(10);
    v_moco_cant_medi      number(20, 4);
    v_moco_anex_codi      number(20);
    v_moco_indi_excl_cont varchar2(1);
    v_moco_anex_nume_item number(10);
    v_moco_juri_codi      number(20);
    v_moco_indi_orse_adm  varchar2(1);
    v_moco_sucu_codi      number(20);
  
    v_moim_movi_codi               number;
    v_moco_impu_desc               varchar2(100);
    v_moco_impu_porc               number(20, 4);
    v_moco_impu_porc_base_impo     number(20, 4);
    v_moco_impu_indi_baim_impu_inc varchar2(1);
  
    v_impo_grav number(20, 4);
    v_impo_iva  number(20, 4);
  
    v_impo_mone           number;
    v_impo_mmnn           number;
    v_moim_impo_mone_ii   number;
    v_moim_impo_mmnn_ii   number;
    v_moim_grav10_ii_mone number;
    v_moim_grav5_ii_mone  number;
    v_moim_grav10_ii_mmnn number;
    v_moim_grav5_ii_mmnn  number;
    v_moim_grav10_mone    number;
    v_moim_grav5_mone     number;
    v_moim_grav10_mmnn    number;
    v_moim_grav5_mmnn     number;
    v_moim_iva10_mone     number;
    v_moim_iva5_mone      number;
    v_moim_iva10_mmnn     number;
    v_moim_iva5_mmnn      number;
    v_moim_exen_mone      number;
    v_moim_exen_mmnn      number;
  
    -----------------------
    --- variables para come_movi_cuot
    v_cuot_fech_venc           date;
    v_cuot_nume                number(10);
    v_cuot_impo_mone           number(20, 4);
    v_cuot_impo_mmnn           number(20, 4);
    v_cuot_impo_mmee           number(20, 4);
    v_cuot_sald_mone           number;
    v_cuot_sald_mmnn           number(20, 4);
    v_cuot_sald_mmee           number(20, 4);
    v_cuot_movi_codi           number(20);
    v_cuot_base                number(2);
    v_cuot_impo_dife_camb      number(20, 4);
    v_cuot_indi_proc_dife_camb varchar2(1);
    v_cuot_impo_dife_camb_sald number(20, 4);
    v_cuot_tasa_dife_camb      number(20, 4);
    v_cuot_orpa_codi           number(20);
    v_cuot_indi_refi           varchar2(1);
    v_cuot_codi                number(10);
    v_cuot_desc                varchar2(60);
    v_cuot_impu_codi           number(10);
    v_cuot_tipo                varchar2(1);
    v_cuot_nume_desc           varchar2(10);
    v_cuot_corr_mes            date;
    v_cuot_obse                varchar2(100);
    v_cuot_id                  number(10);
    v_cuot_indi_reca_reco      varchar2(1);
  
    --variables auxiliares
    --v_movi_fech_venc_timb_char varchar2(10) := '31/03/2021';
  
    v_nume_tran      number := 0;
    v_nume_item      number := 0;
    v_ulti_movi_nume number := 0;
  
    v_impo_nota_cred number;
    v_clpr_codi      number;
  
    v_conc_codi                number;
    v_conc_desc                varchar2(500);
    v_codi_conc_desc_clie_refe number;
    v_codi_impu_grav10         number := to_number(fa_busc_para('p_codi_impu_grav10'));
  
    e_vehi_chas_pate      exception;
    e_codi_conc_refe_clie exception;
    e_codi_impu_grav10    exception;
    e_secu_nume_cred      exception;
    e_fact_inexistente    exception;
  
    v_desc varchar2(5000);
  
  begin
  
    v_codi_conc_desc_clie_refe := to_number(fa_busc_para(p_para_conc_in));
  
    if p_para_conc_in = 'p_codi_prom_10_basa' then
      v_desc := 'PROMO DESCUENTO 10% BASA';
    elsif p_para_conc_in = 'p_codi_prom_5_basa' then
      v_desc := 'PROMO DESCUENTO 5% BASA';
    elsif p_para_conc_in = 'p_codi_prom_cliente_al_dia' then
      v_desc := 'PROMO DESCUENTO CLIENTE AL DIA';
    elsif p_para_conc_in = 'p_codi_prom_cuot_pend' then
      v_desc := 'PROMO CUOTA';
    elsif p_para_conc_in = 'p_codi_fact_error' then
           v_desc := 'DESCUENTO FACTURA NO CORRESPONDIENTE';
    else
      v_desc := 'PROMO PRORRATEO LIBRE';
    end if;
  
    begin
    
      select come_movi.movi_grav_mone + come_movi.movi_exen_mone +
             come_movi.movi_iva_mone,
             come_movi.movi_clpr_codi
        into p_imp_ncr_out, v_clpr_codi
        from come_movi
       where movi_codi = p_clave_fact;
    
    exception
      when others then
        raise e_fact_inexistente;
    end;
  
    --obtener el importe que paga por un vehiculo mensual
    --v_impo_nota_cred := fi_devu_impo_nota_cred(v_clpr_codi_refe) * v_cant_vehi;
    if p_imp_ncr_in is null then
      v_impo_nota_cred := p_imp_ncr_out;
    else
      v_impo_nota_cred := p_imp_ncr_in;
    end if;
  
    --ver su medio de pago
    /*          if v_clpr_mepa_codi = 3 then
      --si es por red de cobranza
      v_impo_nota_cred := v_impo_nota_cred + 5500;
    end if;*/
  
    --buscar el concepto
    begin
      select c.conc_codi, c.conc_desc
        into v_conc_codi, v_conc_desc
        from come_conc c
       where c.conc_codi = nvl(v_codi_conc_desc_clie_refe, 16);
    exception
      when others then
        raise e_codi_conc_refe_clie;
    end;
  
    --datos de impuesto 2 iva 10
    begin
      select impu_desc,
             impu_porc,
             impu_porc_base_impo,
             nvl(impu_indi_baim_impu_incl, 'S'),
             impu_conc_codi_ivdb
        into v_moco_impu_desc,
             v_moco_impu_porc,
             v_moco_impu_porc_base_impo,
             v_moco_impu_indi_baim_impu_inc,
             v_moco_conc_codi_impu
        from come_impu
       where impu_codi = nvl(v_codi_impu_grav10, 2);
    exception
      when others then
        raise e_codi_impu_grav10;
    end;
  
    --ultimo numero de nota de credito
    begin
      select nvl(secu_nume_nota_cred, 0)
        into v_ulti_movi_nume
        from come_secu c
       where secu_codi = 2;
    exception
      when others then
        raise e_secu_nume_cred;
    end;
  
    begin
    
      select t.setc_nume_timb, t.setc_fech_venc, t.setc_fech_inic
        into v_movi_nume_timb, v_movi_fech_venc_timb, v_movi_fech_inic_timb
        from come_secu_tipo_comp t
       where t.setc_secu_codi = 2
         and t.setc_tico_codi = 8;
    
    exception
      when others then
        raise_application_error(-20001, 'Error al obtener el timbrado');
    end;
  
    --desglosa los importes
    pa_devu_impo_calc(v_impo_nota_cred,
                      0,
                      v_moco_impu_porc,
                      v_moco_impu_porc_base_impo,
                      v_moco_impu_indi_baim_impu_inc,
                      v_moco_impo_mone_ii,
                      v_moco_grav10_ii_mone,
                      v_moco_grav5_ii_mone,
                      v_moco_grav10_mone,
                      v_moco_grav5_mone,
                      v_moco_iva10_mone,
                      v_moco_iva5_mone,
                      v_moco_exen_mone);
  
    v_impo_grav := nvl(v_moco_grav10_mone, 0) + nvl(v_moco_grav5_mone, 0);
    v_impo_iva  := nvl(v_moco_iva10_mone, 0) + nvl(v_moco_iva5_mone, 0);
  
    --------comienza la asignacion de valores
    --genera la nota de credito
    v_nume_tran := v_ulti_movi_nume + 1;
  
    --asignar valores....
    v_movi_codi                := fa_sec_come_movi;
    v_movi_timo_codi           := 9; ---nota de credito emit cr
    v_movi_clpr_codi           := v_clpr_codi;
    v_movi_sucu_codi_orig      := 1;
    v_movi_depo_codi_orig      := 1;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := 8; --dev. ventas
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := 1;
    v_movi_nume                := v_nume_tran;
    v_movi_fech_emis           := trunc(sysdate);
    v_movi_fech_oper           := trunc(sysdate);
    v_movi_fech_grab           := sysdate;
    v_movi_user                := gen_user;
    v_movi_codi_padr           := p_clave_fact;
    v_movi_tasa_mone           := 1;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := v_impo_grav;
    v_movi_exen_mmnn           := v_moco_exen_mone;
    v_movi_iva_mmnn            := v_impo_iva;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := v_impo_grav;
    v_movi_exen_mone           := v_moco_exen_mone;
    v_movi_iva_mone            := v_impo_iva;
    v_movi_obse                := v_desc;
    v_movi_sald_mmnn           := nvl(v_movi_grav_mmnn, 0) +
                                  nvl(v_movi_exen_mmnn, 0) +
                                  nvl(v_movi_iva_mmnn, 0);
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := nvl(v_movi_grav_mone, 0) +
                                  nvl(v_movi_exen_mone, 0) +
                                  nvl(v_movi_iva_mone, 0);
    v_movi_stoc_suma_rest      := 'S';
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := 'E';
    v_movi_afec_sald           := 'C';
    v_movi_dbcr                := 'C';
    v_movi_stoc_afec_cost_prom := 'N';
    v_movi_empr_codi           := 1;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := 'S';
    v_movi_empl_codi           := 1;
    --v_movi_nume_timb           := 14018874; --estaba con este valor por defecto
    --v_movi_fech_venc_timb      := v_movi_fech_venc_timb;
    v_movi_codi_rete           := null;
    v_movi_impo_mone_ii        := v_moco_impo_mone_ii;
    v_movi_impo_mmnn_ii        := v_moco_impo_mone_ii;
    v_movi_grav10_ii_mone      := v_moco_grav10_ii_mone;
    v_movi_grav5_ii_mone       := v_moco_grav5_ii_mone;
    v_movi_grav10_ii_mmnn      := v_moco_grav10_ii_mone;
    v_movi_grav5_ii_mmnn       := v_moco_grav5_ii_mone;
    v_movi_grav10_mone         := v_moco_grav10_mone;
    v_movi_grav5_mone          := v_moco_grav5_mone;
    v_movi_grav10_mmnn         := v_moco_grav10_mone;
    v_movi_grav5_mmnn          := v_moco_grav5_mone;
    v_movi_iva10_mone          := v_moco_iva10_mone;
    v_movi_iva5_mone           := v_moco_iva5_mone;
    v_movi_iva10_mmnn          := v_moco_iva10_mone;
    v_movi_iva5_mmnn           := v_moco_iva5_mone;
    v_movi_clpr_sucu_nume_item := null;
    v_movi_fact_codi           := p_clave_fact;
    v_movi_indi_apli_tick      := 'N';
  
    --inserta come_movi
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_depo_codi_orig,
       movi_sucu_codi_dest,
       movi_depo_codi_dest,
       movi_oper_codi,
       movi_cuen_codi,
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
       movi_obse,
       movi_sald_mmnn,
       movi_sald_mmee,
       movi_sald_mone,
       movi_stoc_suma_rest,
       movi_clpr_dire,
       movi_clpr_tele,
       movi_clpr_ruc,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_stoc_afec_cost_prom,
       movi_empr_codi,
       movi_clave_orig,
       movi_clave_orig_padr,
       movi_indi_iva_incl,
       movi_empl_codi,
       movi_base,
       movi_nume_timb,
       movi_fech_oper,
       movi_fech_venc_timb,
       movi_codi_rete,
       movi_excl_cont,
       movi_impo_mone_ii,
       movi_impo_mmnn_ii,
       movi_grav10_ii_mone,
       movi_grav5_ii_mone,
       movi_grav10_ii_mmnn,
       movi_grav5_ii_mmnn,
       movi_grav10_mone,
       movi_grav5_mone,
       movi_grav10_mmnn,
       movi_grav5_mmnn,
       movi_iva10_mone,
       movi_iva5_mone,
       movi_iva10_mmnn,
       movi_iva5_mmnn,
       movi_clpr_sucu_nume_item,
       movi_indi_apli_tick,
       movi_fact_codi,
       movi_fech_inic_timb,
       MOVI_INDI_PROG_ORIG)
    values
      (v_movi_codi,
       v_movi_timo_codi,
       v_movi_clpr_codi,
       v_movi_sucu_codi_orig,
       v_movi_depo_codi_orig,
       v_movi_sucu_codi_dest,
       v_movi_depo_codi_dest,
       v_movi_oper_codi,
       v_movi_cuen_codi,
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
       v_movi_obse,
       v_movi_sald_mmnn,
       v_movi_sald_mmee,
       v_movi_sald_mone,
       v_movi_stoc_suma_rest,
       v_movi_clpr_dire,
       v_movi_clpr_tele,
       v_movi_clpr_ruc,
       v_movi_clpr_desc,
       v_movi_emit_reci,
       v_movi_afec_sald,
       v_movi_dbcr,
       v_movi_stoc_afec_cost_prom,
       v_movi_empr_codi,
       v_movi_clave_orig,
       v_movi_clave_orig_padr,
       v_movi_indi_iva_incl,
       v_movi_empl_codi,
       1,
       v_movi_nume_timb,
       v_movi_fech_oper,
       v_movi_fech_venc_timb,
       v_movi_codi_rete,
       v_movi_excl_cont,
       v_movi_impo_mone_ii,
       v_movi_impo_mmnn_ii,
       v_movi_grav10_ii_mone,
       v_movi_grav5_ii_mone,
       v_movi_grav10_ii_mmnn,
       v_movi_grav5_ii_mmnn,
       v_movi_grav10_mone,
       v_movi_grav5_mone,
       v_movi_grav10_mmnn,
       v_movi_grav5_mmnn,
       v_movi_iva10_mone,
       v_movi_iva5_mone,
       v_movi_iva10_mmnn,
       v_movi_iva5_mmnn,
       v_movi_clpr_sucu_nume_item,
       v_movi_indi_apli_tick,
       v_movi_fact_codi,
       v_movi_fech_inic_timb,
       'I010054');
  
    --come_movi_impu_deta
    v_moco_impu_codi    := nvl(v_codi_impu_grav10, 2);
    v_moim_movi_codi    := v_movi_codi;
    v_impo_mmnn         := v_moco_grav10_mone;
    v_impo_mone         := v_moco_grav10_mone;
    v_moim_impo_mone_ii := v_moco_grav10_ii_mone;
    v_moim_impo_mmnn_ii := v_moco_grav10_ii_mone;
  
    v_moim_grav10_ii_mone := v_moco_grav10_ii_mone;
    v_moim_grav5_ii_mone  := v_moco_grav5_ii_mone;
    v_moim_grav10_ii_mmnn := v_moco_grav10_ii_mone;
    v_moim_grav5_ii_mmnn  := v_moco_grav5_ii_mone;
    v_moim_grav10_mone    := v_moco_grav10_mone;
    v_moim_grav5_mone     := v_moco_grav5_mone;
    v_moim_grav10_mmnn    := v_moco_grav10_mone;
    v_moim_grav5_mmnn     := v_moco_grav5_mone;
    v_moim_iva10_mone     := v_moco_iva10_mone;
    v_moim_iva5_mone      := v_moco_iva5_mone;
    v_moim_iva10_mmnn     := v_moco_iva10_mone;
    v_moim_iva5_mmnn      := v_moco_iva5_mone;
    v_moim_exen_mone      := v_moco_exen_mone;
    v_moim_exen_mmnn      := v_moco_exen_mmnn;
  
    --inserta come_movi_impu_deta
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_tiim_codi,
       moim_impo_mone_ii,
       moim_impo_mmnn_ii,
       moim_grav10_ii_mone,
       moim_grav5_ii_mone,
       moim_grav10_ii_mmnn,
       moim_grav5_ii_mmnn,
       moim_grav10_mone,
       moim_grav5_mone,
       moim_grav10_mmnn,
       moim_grav5_mmnn,
       moim_iva10_mone,
       moim_iva5_mone,
       moim_iva10_mmnn,
       moim_iva5_mmnn,
       moim_exen_mone,
       moim_exen_mmnn,
       moim_base)
    values
      (v_moco_impu_codi,
       v_moim_movi_codi,
       v_impo_mmnn,
       0,
       v_moco_iva10_mone,
       0,
       v_impo_mone,
       v_moco_iva10_mone,
       1,
       v_moim_impo_mone_ii,
       v_moim_impo_mmnn_ii,
       v_moim_grav10_ii_mone,
       v_moim_grav5_ii_mone,
       v_moim_grav10_ii_mmnn,
       v_moim_grav5_ii_mmnn,
       v_moim_grav10_mone,
       v_moim_grav5_mone,
       v_moim_grav10_mmnn,
       v_moim_grav5_mmnn,
       v_moim_iva10_mone,
       v_moim_iva5_mone,
       v_moim_iva10_mmnn,
       v_moim_iva5_mmnn,
       v_moim_exen_mone,
       v_moim_exen_mmnn,
       1);
  
    --carga come_movi_conc_deta
    v_moco_nume_item      := 0;
    v_moco_nume_item      := v_moco_nume_item + 1;
    v_moco_movi_codi      := v_movi_codi;
    v_moco_nume_item      := v_moco_nume_item;
    v_moco_conc_codi      := v_conc_codi;
    v_moco_cuco_codi      := null;
    v_moco_impu_codi      := nvl(v_codi_impu_grav10, 2);
    v_moco_impo_mmnn      := v_impo_grav;
    v_moco_impo_mmee      := 0;
    v_moco_impo_mone      := v_impo_grav;
    v_moco_dbcr           := 'D';
    v_moco_base           := 1;
    v_moco_desc           := v_conc_desc; --||' chasis: '||v_vehi_nume_chas||' chapa: '||v_vehi_nume_pate;
    v_moco_tiim_codi      := null;
    v_moco_indi_fact_serv := 'S';
    v_moco_impo_mone_ii   := v_movi_impo_mone_ii;
    v_moco_ortr_codi      := null;
    v_moco_impo_codi      := null;
    v_moco_cant           := 1;
    v_moco_cant_pulg      := null;
    v_moco_movi_codi_padr := null;
    v_moco_nume_item_padr := null;
    v_moco_ceco_codi      := null;
    v_moco_orse_codi      := null;
    v_moco_osli_codi      := null;
    v_moco_tran_codi      := null;
    v_moco_bien_codi      := null;
    v_moco_emse_codi      := null;
    v_moco_impo_mmnn_ii   := v_movi_impo_mone_ii;
    v_moco_sofa_sose_codi := null;
    v_moco_sofa_nume_item := null;
    v_moco_tipo_item      := null;
    v_moco_clpr_codi      := null;
    v_moco_prod_nume_item := null;
    v_moco_guia_nume      := null;
    v_moco_grav10_ii_mone := v_movi_impo_mone_ii;
    v_moco_grav5_ii_mone  := 0;
    v_moco_grav10_ii_mmnn := v_movi_impo_mone_ii;
    v_moco_grav5_ii_mmnn  := 0;
    v_moco_grav10_mone    := v_impo_grav;
    v_moco_grav5_mone     := 0;
    v_moco_grav10_mmnn    := v_impo_grav;
    v_moco_grav5_mmnn     := 0;
    v_moco_iva10_mone     := v_moco_iva10_mone;
    v_moco_iva5_mone      := 0;
    v_moco_conc_codi_impu := 13; --iva 10% cr
    v_moco_tipo           := 'C';
    v_moco_prod_codi      := null;
    v_moco_ortr_codi_fact := null;
    v_moco_iva10_mmnn     := v_moco_iva10_mone;
    v_moco_iva5_mmnn      := 0;
    v_moco_exen_mone      := 0;
    v_moco_exen_mmnn      := 0;
    v_moco_empl_codi      := null;
    v_moco_lote_codi      := null;
    v_moco_bene_codi      := null;
    v_moco_medi_codi      := null;
    v_moco_cant_medi      := null;
    v_moco_anex_codi      := null;
    v_moco_indi_excl_cont := null;
    v_moco_anex_nume_item := null;
    v_moco_juri_codi      := null;
    v_moco_indi_orse_adm  := null;
    v_moco_sucu_codi      := null;
  
    --inserta come_movi_conc_deta
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
       moco_base,
       moco_desc,
       moco_tiim_codi,
       moco_indi_fact_serv,
       moco_impo_mone_ii,
       moco_ortr_codi,
       moco_impo_codi,
       moco_cant,
       moco_cant_pulg,
       moco_movi_codi_padr,
       moco_nume_item_padr,
       moco_ceco_codi,
       moco_orse_codi,
       moco_osli_codi,
       moco_tran_codi,
       moco_bien_codi,
       moco_emse_codi,
       moco_impo_mmnn_ii,
       moco_sofa_sose_codi,
       moco_sofa_nume_item,
       moco_tipo_item,
       moco_clpr_codi,
       moco_prod_nume_item,
       moco_guia_nume,
       moco_grav10_ii_mone,
       moco_grav5_ii_mone,
       moco_grav10_ii_mmnn,
       moco_grav5_ii_mmnn,
       moco_grav10_mone,
       moco_grav5_mone,
       moco_grav10_mmnn,
       moco_grav5_mmnn,
       moco_iva10_mone,
       moco_iva5_mone,
       moco_conc_codi_impu,
       moco_tipo,
       moco_prod_codi,
       moco_ortr_codi_fact,
       moco_iva10_mmnn,
       moco_iva5_mmnn,
       moco_exen_mone,
       moco_exen_mmnn,
       moco_empl_codi,
       moco_lote_codi,
       moco_bene_codi,
       moco_medi_codi,
       moco_cant_medi,
       moco_anex_codi,
       moco_indi_excl_cont,
       moco_anex_nume_item,
       moco_juri_codi,
       moco_indi_orse_adm,
       moco_sucu_codi)
    values
      (v_moco_movi_codi,
       v_moco_nume_item,
       v_moco_conc_codi,
       v_moco_cuco_codi,
       v_moco_impu_codi,
       v_moco_impo_mmnn,
       v_moco_impo_mmee,
       v_moco_impo_mone,
       v_moco_dbcr,
       v_moco_base,
       v_moco_desc,
       v_moco_tiim_codi,
       v_moco_indi_fact_serv,
       v_moco_impo_mone_ii,
       v_moco_ortr_codi,
       v_moco_impo_codi,
       v_moco_cant,
       v_moco_cant_pulg,
       v_moco_movi_codi_padr,
       v_moco_nume_item_padr,
       v_moco_ceco_codi,
       v_moco_orse_codi,
       v_moco_osli_codi,
       v_moco_tran_codi,
       v_moco_bien_codi,
       v_moco_emse_codi,
       v_moco_impo_mmnn_ii,
       v_moco_sofa_sose_codi,
       v_moco_sofa_nume_item,
       v_moco_tipo_item,
       v_moco_clpr_codi,
       v_moco_prod_nume_item,
       v_moco_guia_nume,
       v_moco_grav10_ii_mone,
       v_moco_grav5_ii_mone,
       v_moco_grav10_ii_mmnn,
       v_moco_grav5_ii_mmnn,
       v_moco_grav10_mone,
       v_moco_grav5_mone,
       v_moco_grav10_mmnn,
       v_moco_grav5_mmnn,
       v_moco_iva10_mone,
       v_moco_iva5_mone,
       v_moco_conc_codi_impu,
       v_moco_tipo,
       v_moco_prod_codi,
       v_moco_ortr_codi_fact,
       v_moco_iva10_mmnn,
       v_moco_iva5_mmnn,
       v_moco_exen_mone,
       v_moco_exen_mmnn,
       v_moco_empl_codi,
       v_moco_lote_codi,
       v_moco_bene_codi,
       v_moco_medi_codi,
       v_moco_cant_medi,
       v_moco_anex_codi,
       v_moco_indi_excl_cont,
       v_moco_anex_nume_item,
       v_moco_juri_codi,
       v_moco_indi_orse_adm,
       v_moco_sucu_codi);
  
    -------------------------------------------------------------------------------------
    --come_movi_cuot
    v_nume_item := 0;
    v_nume_item := v_nume_item + 1;
    --asigna valores
    v_cuot_fech_venc           := trunc(sysdate);
    v_cuot_nume                := v_nume_item;
    v_cuot_impo_mone           := v_movi_impo_mone_ii;
    v_cuot_impo_mmnn           := v_movi_impo_mone_ii;
    v_cuot_impo_mmee           := 0;
    v_cuot_sald_mone           := v_movi_impo_mone_ii;
    v_cuot_sald_mmnn           := v_movi_impo_mone_ii;
    v_cuot_sald_mmee           := 0;
    v_cuot_movi_codi           := v_movi_codi;
    v_cuot_base                := 1;
    v_cuot_impo_dife_camb      := 0;
    v_cuot_indi_proc_dife_camb := null;
    v_cuot_impo_dife_camb_sald := 0;
    v_cuot_tasa_dife_camb      := 0;
    v_cuot_orpa_codi           := null;
    v_cuot_indi_refi           := 'N';
    v_cuot_codi                := null;
    v_cuot_desc                := null;
    v_cuot_impu_codi           := null;
    v_cuot_tipo                := 'C';
    v_cuot_nume_desc           := '0/0';
    v_cuot_corr_mes            := null;
    v_cuot_obse                := null;
    v_cuot_id                  := null;
    v_cuot_indi_reca_reco      := null;
  
    --inserta come_movi_cuot
    insert into come_movi_cuot
      (cuot_fech_venc,
       cuot_nume,
       cuot_impo_mone,
       cuot_impo_mmnn,
       cuot_impo_mmee,
       cuot_sald_mone,
       cuot_sald_mmnn,
       cuot_sald_mmee,
       cuot_movi_codi,
       cuot_base,
       cuot_impo_dife_camb,
       cuot_indi_proc_dife_camb,
       cuot_impo_dife_camb_sald,
       cuot_tasa_dife_camb,
       cuot_orpa_codi,
       cuot_indi_refi,
       cuot_codi,
       cuot_desc,
       cuot_impu_codi,
       cuot_tipo,
       cuot_nume_desc,
       cuot_corr_mes,
       cuot_obse,
       cuot_id,
       cuot_indi_reca_reco)
    values
      (v_cuot_fech_venc,
       v_cuot_nume,
       v_cuot_impo_mone,
       v_cuot_impo_mmnn,
       v_cuot_impo_mmee,
       v_cuot_sald_mone,
       v_cuot_sald_mmnn,
       v_cuot_sald_mmee,
       v_cuot_movi_codi,
       v_cuot_base,
       v_cuot_impo_dife_camb,
       v_cuot_indi_proc_dife_camb,
       v_cuot_impo_dife_camb_sald,
       v_cuot_tasa_dife_camb,
       v_cuot_orpa_codi,
       v_cuot_indi_refi,
       v_cuot_codi,
       v_cuot_desc,
       v_cuot_impu_codi,
       v_cuot_tipo,
       v_cuot_nume_desc,
       v_cuot_corr_mes,
       v_cuot_obse,
       v_cuot_id,
       v_cuot_indi_reca_reco);
  
    --actualiza la secuencia de nota de credito
    update come_secu
       set secu_nume_nota_cred = v_nume_tran
     where secu_codi =
           (select peco_secu_codi from come_pers_comp where peco_codi = 7);
  
    -----------------genera la aplicacion de la nc   
    pp_actualiza_canc(p_movi_codi_nc => v_movi_codi);
  
    -- env_fact_sifen.pp_get_json_fact(v_movi_codi);
  
  exception
    when e_codi_conc_refe_clie then
      raise_application_error(-20001,
                              'Error al recuperar concepto de Descuento Por Referencia');
    when e_codi_impu_grav10 then
      raise_application_error(-20002,
                              'Error al recuperar impuesto de Grav 10%');
    when e_secu_nume_cred then
      raise_application_error(-20003,
                              'Error al recuperar secuencia de numeracion de Nota de Credito');
    when e_fact_inexistente then
      raise_application_error(-20004,
                              'Error al recuperar datos de la factura');
  end;

  -----------------------------nota de credito por cuota 

  procedure pp_fact_cuot_libre is
    cursor clientes is(
      select distinct (movi_clpr_codi) cliente
        from come_movi
       where movi_timo_codi = 13
         and movi_fech_emis = trunc(sysdate));
  
  begin
    for x in clientes loop
      I010054.pp_promo_cuot_libre(x.cliente);
    end loop;
  
  end;

  procedure pp_promo_cuot_libre(p_cliente in number) is
  
    v_cant_pagadas         number;
    v_factura_saldo        number;
    v_factura_saldo_dev    number; ---por si enviemos el valor nulo
    v_factura_cuota        number;
    v_defa_cant_cuot_pag   number;
    v_defa_cant_cuot_pag_H number;
    v_defa_cant_cuot_desc  number;
    v_Cantidad_asignado    number;
    v_situacion            number;
  begin
    --------------------buscamos la situacion del cliente
    begin
      select cp.clpr_cli_situ_codi
        into v_situacion
        from come_clie_prov cp
       where cp.clpr_codi = p_cliente;
    exception
      when others then
        v_situacion := null;
    end;
  
    begin
      select defa_cant_cuot_desc, defa_cant_cuot_pag_h
        into v_defa_cant_cuot_desc, v_defa_cant_cuot_pag_h
        from come_desc_fact
       where trunc(sysdate) between defa_fech_desd and defa_fech_hast
         and defa_situacion = v_situacion;
    exception
      when others then
        v_defa_cant_cuot_desc  := null;
        v_defa_cant_cuot_pag_h := null;
      
    end;
  
    if v_defa_cant_cuot_pag_h is not null or
       v_defa_cant_cuot_desc is not null then
      select count(mc.movi_codi)
        into v_cant_pagadas
        from come_movi_cuot_canc a, come_movi mc, come_movi_cuot c
       where a.canc_movi_codi = mc.movi_codi
         and mc.movi_fech_emis = trunc(sysdate)
         and a.canc_cuot_fech_venc = c.cuot_fech_venc
         and a.canc_cuot_movi_codi = c.cuot_movi_codi
         and a.canc_tipo = c.cuot_tipo
         and c.cuot_sald_mone = 0
         and movi_clpr_codi = p_cliente ---10063177901
         and mc.movi_timo_codi <> 9
       group by movi_clpr_codi;
    
      if v_cant_pagadas >= v_defa_cant_cuot_pag_h then
        -------------------------------revisamos si tiene factura con cuotas para poder dar de baja
        for i in 1 .. v_defa_cant_cuot_desc loop
        
          select nvl(count(defc_movi_codi), 0)
            into v_Cantidad_asignado
            from come_desc_fact_clie
           where defc_clpr_codi = p_cliente
             and defc_fech_desc = trunc(sysdate);
        
          if v_Cantidad_asignado >= v_defa_cant_cuot_desc then
            null;
          else
            select min(cuot_movi_codi)
              into v_factura_cuota
              from come_movi, come_movi_cuot
             where movi_codi = cuot_movi_codi
               and movi_timo_codi in (2, 45) ---factura credito y saldo inicial
               and movi_clpr_codi = p_cliente
               and cuot_sald_mone > 0
             order by cuot_fech_venc;
          
            if v_factura_cuota is null then
              --------------si no tiene facturas pendientes se aplica al plan
              for x in (select d.deta_anex_codi anexo,
                               d.deta_codi detalle,
                               min(p.anpl_fech_desd) desde,
                               min(p.anpl_fech_hast) hasta
                          from come_soli_serv           s,
                               come_soli_serv_anex      a,
                               come_soli_serv_anex_deta d,
                               come_soli_serv_anex_plan p
                         where s.sose_codi = a.anex_codi
                           and a.anex_codi = d.deta_codi
                           and d.deta_codi = p.anpl_deta_codi
                           and d.deta_anex_codi = p.anpl_anex_codi
                           and s.sose_clpr_codi = p_cliente
                           and p.anpl_deta_esta_plan = 'S'
                           and p.anpl_indi_fact_cuot = 'N'
                           and p.anpl_movi_codi is null
                         group by d.deta_anex_codi, d.deta_codi) loop
              
                update come_soli_serv_anex_plan
                   set anpl_deta_esta_plan = 'N',
                       anpl_obse           = 'PROMO PAGUE X CUOTAS LE REGALAMOS 1'
                 where anpl_deta_codi = x.detalle
                   and anpl_anex_codi = x.anexo
                   and anpl_fech_desd = x.desde
                   and anpl_fech_hast = x.hasta;
              
              end loop;
            else
            
              select sum(cuot_sald_mone)
                into v_factura_saldo
                from come_movi, come_movi_cuot
               where movi_codi = cuot_movi_codi
                 and movi_timo_codi in (2, 45) ---factura credito y saldo inicial
                 and movi_clpr_codi = p_cliente
                 and cuot_sald_mone > 0
                 and movi_codi = v_factura_cuota
               order by cuot_fech_venc;
            
              i010054.pa_gene_nota_cred(p_clave_fact   => v_factura_cuota,
                                        p_imp_ncr_in   => v_factura_saldo,
                                        p_imp_ncr_out  => v_factura_saldo_dev,
                                        p_para_conc_in => 'p_codi_prom_cuot_pend');
            
            end if;
            dbms_output.put_line('Iteraci?n ' || i || ' de ' ||
                                 v_defa_cant_cuot_desc);
          
            insert into come_desc_fact_clie
              (defc_clpr_codi, defc_fech_desc, defc_movi_codi)
            values
              (p_cliente, trunc(sysdate), v_factura_cuota);
          end if;
        
        end loop;
      end if;
    end if;
    commit;
  
  end pp_promo_cuot_libre;

  procedure pp_actualizar_desc_fact(p_defa_codi            in number,
                                    p_fech_desd            in date,
                                    p_fech_hast            in date,
                                    p_situacion            in number,
                                    p_cant_cuot_desc       in number,
                                    P_defa_cant_cuot_pag_h in number) is
    v_defa_codigo    number;
    v_cant_fact      number;
    v_situ_desc      varchar2(300);
    v_user           varchar2(60) := gen_user;
    v_desi_fech_grab date;
    v_desi_user_grab varchar2(60);
  begin
  
    if p_fech_desd is null then
      raise_application_error(-20001,
                              'La fecha desde no puede quedar vacia');
    end if;
    if p_fech_hast is null then
      raise_application_error(-20001,
                              'La fecha hasta no puede quedar vacia');
    end if;
    if p_fech_desd > p_fech_hast then
      raise_application_error(-20001,
                              'La fecha desde no puede ser mayor a la fecha hasta');
    end if;
    if p_situacion is null then
      raise_application_error(-20001, 'La situacion no puede quedar vacia');
    end if;
  
    if p_cant_cuot_desc is null then
      raise_application_error(-20001,
                              'La cantidad de cuotas que recibiran descuento no puede quedar vacia');
    end if;
  
    if p_defa_codi is null then
    
      select nvl(max(defa_codi), 0) + 1
        into v_defa_codigo
        from come_desc_fact;
    
      select count(*)
        into v_cant_fact
        from come_desc_fact
       where defa_situacion = p_situacion
         and (p_fech_desd between defa_fech_desd and defa_fech_hast or
             p_fech_hast between defa_fech_desd and defa_fech_hast);
    
      if v_cant_fact > 0 then
        raise_application_error(-20001,
                                'Ya existe un descuento en el rango de la fecha agregado y de esa situacion');
      end if;
    
      insert into come_desc_fact
        (defa_codi,
         defa_fech_desd,
         defa_fech_hast,
         defa_situacion,
         defa_cant_cuot_pag_h,
         defa_cant_cuot_desc,
         defa_fech_grab,
         defa_user_grab)
      values
        (v_defa_codigo,
         p_fech_desd,
         p_fech_hast,
         p_situacion,
         p_defa_cant_cuot_pag_h,
         p_cant_cuot_desc,
         sysdate,
         gen_user);
    
    else
      select count(*)
        into v_cant_fact
        from come_desc_fact
       where defa_situacion = p_situacion
         and (p_fech_desd between defa_fech_desd and defa_fech_hast or
             p_fech_hast between defa_fech_desd and defa_fech_hast)
         and defa_codi <> p_defa_codi;
    
      if v_cant_fact > 0 then
        raise_application_error(-20001,
                                'Ya existe un descuento en el rango de la fecha agregado');
      end if;
    
      update come_desc_fact
         set defa_fech_desd       = p_fech_desd,
             defa_fech_hast       = p_fech_hast,
             defa_situacion       = p_situacion,
             defa_cant_cuot_desc  = p_cant_cuot_desc,
             defa_cant_cuot_pag_h = P_defa_cant_cuot_pag_h,
             defa_fech_modi       = sysdate,
             defa_user_modi       = gen_user
       where defa_codi = p_defa_codi;
    
    end if;
  
  end pp_actualizar_desc_fact;
  procedure pp_borrar_desc_fact(p_defa_codi in number) is
  
  begin
  
    delete come_desc_fact where defa_codi = p_defa_codi;
  
  end pp_borrar_desc_fact;

  ----22/01/2023--------------------------------------------------*************************

  procedure pp_actualizar_new_client(p_desi_codi      in number,
                                     p_porc_desc      in number,
                                     p_cont_fech      in date,
                                     p_fech_cont_hast in date,
                                     p_fech_desc      in date,
                                     p_fech_hasta     in date,
                                     p_ilimitado      in varchar2,
                                     p_situ           in varchar2) is
    v_desi_codigo    number;
    v_cant_situ      number;
    v_situ_desc      varchar2(300);
    v_user           varchar2(60) := gen_user;
    v_desi_fech_grab date;
    v_desi_user_grab varchar2(60);
  begin
  
    if p_cont_fech is null then
      raise_application_error(-20001,
                              'La fecha de contrato desde no puede quedar vacia');
    end if;
    if p_fech_hasta is null then
      raise_application_error(-20001,
                              'La fecha de contrato hasta no puede quedar vacia');
    end if;
    if p_fech_desc is null then
      raise_application_error(-20001,
                              'La fecha aplicar descuento desde no puede quedar vacia');
    end if;
    if p_cont_fech > p_fech_hasta then
      raise_application_error(-20001,
                              'La fecha contrato hasta no puede ser mayor a la fecha desde');
    end if;
    if p_porc_desc is null then
      raise_application_error(-20001,
                              'El porcentaje descuento no puede quedar vacio');
    end if;
    if p_situ is null then
      raise_application_error(-20001,
                              'Debe elegir por lo menos una situacion');
    end if;
  
    if p_desi_codi is null then
    
      select nvl(max(decl_codigo), 0) + 1
        into v_desi_codigo
        from come_desc_nuev_clie;
    
      for x in (select regexp_substr(p_situ, '[^:]+', 1, level) situacion
                  from dual
                connect by level <= regexp_count(p_situ, ':') + 1) loop
      
        select count(*)
          into v_cant_situ
          from come_desc_nuev_clie t
         where t.decl_situ_codi = x.situacion
           and (p_cont_fech between decl_fech_cont and decl_fech_cont_hast or
               p_fech_cont_hast between decl_fech_cont and
               decl_fech_cont_hast);
      
        if v_cant_situ > 0 then
          select situ_desc
            into v_situ_desc
            from come_situ_clie
           where situ_codi = x.situacion;
        
          raise_application_error(-20001,
                                  'La situacion: ' || v_situ_desc ||
                                  ' ya tiene un descuento para el rango de fecha agregado');
        end if;
      
        insert into come_desc_nuev_clie
          (decl_codigo,
           decl_situ_codi,
           decl_proc_desc,
           decl_fech_cont,
           decl_fech_cont_hast,
           decl_fech_desde,
           decl_fech_hasta,
           decl_indi_limi,
           decl_user_grab,
           decl_fech_grab)
        values
          (v_desi_codigo,
           x.situacion,
           p_porc_desc,
           p_cont_fech,
           p_fech_cont_hast,
           p_fech_desc,
           p_fech_hasta,
           p_ilimitado,
           v_user,
           sysdate);
      
      end loop;
    
    else
    
      select decl_fech_grab, decl_user_grab
        into v_desi_fech_grab, v_desi_user_grab
        from come_desc_nuev_clie
       where decl_codigo = p_desi_codi
       group by decl_fech_grab, decl_user_grab;
    
      -- raise_application_error(-20001,'La situacion:'||v_desi_fech_grab||'--'||v_desi_user_grab); 
      delete come_desc_nuev_clie where decl_codigo = p_desi_codi;
    
      for x in (select regexp_substr(p_situ, '[^:]+', 1, level) situacion
                  from dual
                connect by level <= regexp_count(p_situ, ':') + 1) loop
      
        select count(*)
          into v_cant_situ
          from come_desc_nuev_clie t
         where t.decl_situ_codi = x.situacion
           and (p_cont_fech between decl_fech_cont and decl_fech_cont_hast or
               p_fech_cont_hast between decl_fech_cont and
               decl_fech_cont_hast);
      
        if v_cant_situ > 0 then
          select situ_desc
            into v_situ_desc
            from come_situ_clie
           where situ_codi = x.situacion;
        
          raise_application_error(-20001,
                                  'La situacion: ' || v_situ_desc ||
                                  ' ya tiene un descuento para el rango de fecha agregado');
        end if;
      
        insert into come_desc_nuev_clie
          (decl_codigo,
           decl_situ_codi,
           decl_proc_desc,
           decl_fech_cont,
           decl_fech_cont_hast,
           decl_fech_desde,
           decl_fech_hasta,
           decl_indi_limi,
           decl_user_grab,
           decl_fech_grab,
           decl_user_modi,
           decl_fech_modi)
        values
          (p_desi_codi,
           x.situacion,
           p_porc_desc,
           p_cont_fech,
           p_fech_cont_hast,
           p_fech_desc,
           p_fech_hasta,
           p_ilimitado,
           v_desi_user_grab,
           v_desi_fech_grab,
           v_user,
           sysdate);
      
      end loop;
    end if;
  
  end pp_actualizar_new_client;

  procedure pp_borrar_new_client(p_desi_codi in number) is
  
  begin
  
    delete come_desc_nuev_clie where decl_codigo = p_desi_codi;
  
  end pp_borrar_new_client;
end I010054;
