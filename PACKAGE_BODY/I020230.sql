
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020230" is

  -- Private type declarations
  type r_parameter is record (
      collection_bcheq        varchar2(30) := 'COLL_BCHEQ_EMIT',
      collection_bcuota       varchar2(30) := 'COLL_BCUOTA',
      collection_bcaja        varchar2(30) := 'COLL_BCAJA',
      p_max_nume_item         number,
      p_indi_carg_cuot        varchar2(1)  := 's',
      p_movi_codi             number,
      p_movi_nume             number,
      p_hab_desh_cuotas       varchar2(1)  := 'N',
      p_hab_desh_cheque       varchar2(1)  := 'N',
      p_hab_desh_caja         varchar2(1)  := 'N',
      p_codi_peri_actu_rrhh   number       := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_peri_actu_rrhh'))),
      p_indi_refi             varchar2(1)  := 'N'--valores(N= no; I: idividual; S: si)
      
  );
  parameter r_parameter;
  
  
  type r_bsel is record(
      s_empl_codi number,
      s_empl_desc varchar2(100),
      s_fech      varchar2(10),
      s_mes       number,
      s_anho      number,
      s_nume      number,
      s_codi      varchar2(30),
      fech        date
  );
  bsel r_bsel;
  
  type r_bcab is record(
      movi_codi           number,
      movi_nume           number,
      movi_conc_codi      number,
      conc_desc           varchar2(100),
      conc_indi_cuot      varchar2(1),
      conc_indi_caja      varchar2(1),
      s_movi_fech_emis    varchar2(10),
      movi_fech_emis      date,
      movi_empl_codi      number,
      empl_desc           varchar2(100),
      empl_esta           varchar2(1),
      movi_mone_codi      number,
      movi_mone_desc_abre varchar2(100),
      movi_mone_desc       varchar2(100),
      movi_mone_cant_deci number,
      movi_tasa_mone      number,
      movi_impo_mone      number,
      movi_cond_pago      varchar2(2),
      movi_obse           varchar2(500),
      movi_fech_grab      date,
      movi_user           varchar2(20),
      s_impo_efec         number,
      s_impo_cheq         number,
      s_total             number
  );
  bcab r_bcab;
  
  type r_bcheq_emit is record(
      cheq_nume               number,
      cheq_serie              varchar2(3),
      cheq_cuen_codi          number,
      cheq_cuen_desc          varchar2(100),
      cheq_nume_cuen          varchar2(100),
      cheq_banc_codi          number,
      cheq_banc_desc          varchar2(100),
      s_cheq_fech_emis        varchar2(10),
      s_cheq_fech_venc        varchar2(10),
      cheq_tasa_mone          number,
      cheq_impo_mone          number,
      cheq_impo_mmnn          number,
      cheq_impo_mone_movi     number,
      sum_cheq_impo_mone      number,
      sum_cheq_impo_mmnn      number,
      sum_cheq_impo_mone_movi number,
      cheq_mone_codi          number,
      cheq_mone_desc          varchar2(100),
      cheq_mone_desc_abre     varchar2(100),
      cheq_mone_cant_deci     number,
      cheq_orde               varchar2(60)
  );
  bcheq_emit r_bcheq_emit;
  
  type r_bcuota is record(
      s_cuot_fech_venc varchar2(15),
      cuot_impo_mone   number,
      s_total_cuotas   number,
      cuot_nume        number,
      cuot_nume_item   number,
      cuot_fech_venc   date,
      cuot_fech_orig   date,
      cuot_impo_orig   number,
      cuot_impo_mmnn   number,
      dias             number,
      dif              number
  );
  bcuota r_bcuota;
  
  type r_bcuo_enc is record(
      s_cuot_sald         number,
      saldo               number,
      s_dias_entre_cuotas number,
      fec_prim_vto        date,
      cant_cuotas         number,
      s_tipo_vencimiento  varchar2(2)
  );
  bcuo_enc r_bcuo_enc;
  
  type r_bcaja is record(
      item_caja          number,
      moim_cuen_codi     number,
      moim_tipo          varchar2(10),
      moim_cuen_desc     varchar2(100),
      moim_dbcr          varchar2(30),
      moim_impo_mone_db  number,
      moim_impo_mone_cr  number,
      moim_impo_mmnn     number,
      s_total_importe_cr number,
      s_total_importe_db number,
      s_neto             number
  );
  bcaja r_bcaja;
  
  
-----------------------------------------------
  procedure pp_muestra_empl(p_empl_codi in number) is

  v_empl_esta varchar2(1);
  p_empl_desc varchar2(100);

  begin
    
    --raise_application_error(-20010, 'p_empl_codi: '||p_empl_codi);
    
    if p_empl_codi is not null then
      select empl_desc, empl_esta
      into   p_empl_desc, v_empl_esta 
      from   come_empl
      where  empl_codi = p_empl_codi;    
    end if;
    
  Exception
    when no_data_found then
       raise_application_error(-20010, 'Empleado Inexistente!');
    when others then
       raise_application_error(-20010, 'Error al validar Empleado! ' || sqlerrm);
  end pp_muestra_empl;
  
-----------------------------------------------
  procedure pp_validar_movi(s_empl_codi in number,
                            s_fech      in date,
                            s_mes       in number,
                            s_anho      in number,
                            s_nume      in number) is
                            
                            
      v_cant number := 0;
      salir  exception;

    begin

    select count(*)
      into v_cant
      from rrhh_movi
     where movi_nume = s_nume
       and movi_conc_codi = 4
       and (s_empl_codi is null or movi_empl_codi                             = s_empl_codi)
       and (s_fech      is null or movi_fech_emis                             = s_fech)
       and (s_mes       is null or to_number(to_char(movi_fech_emis, 'mm'))   = (s_mes))
       and (s_anho      is null or to_number(to_char(movi_fech_emis, 'yyyy')) = (s_anho))
       --and (s_nume      is null or movi_nume                                  = s_nume)
       ;

    if v_cant = 0 then
      raise salir;
    end if;

    exception
    when salir then
      raise_application_error(-20010, 'Movimiento Inexistente');
    when others then
      raise_application_error(-20010, 'Error al validar Movimiento! ' || sqlerrm);
      
    end pp_validar_movi;
    
-----------------------------------------------
    procedure pp_mostrar_come_mone(p_mone_codi      in number,
                                   p_mone_desc_abre out varchar2,
                                   p_mone_cant_deci out number,
                                   p_mone_desc      out varchar2) is

    begin

      select mone_desc_abre, mone_cant_deci, mone_desc
        into p_mone_desc_abre, p_mone_cant_deci,p_mone_desc
        from come_mone
       where mone_codi = p_mone_codi;

    Exception
      when no_data_found then
        raise_application_error(-20010, 'Moneda inexistente!');
      when others then
        raise_application_error(-20010, 'Error al buscar moneda! ' || sqlerrm);
      
    end pp_mostrar_come_mone;

-----------------------------------------------
    procedure pp_muestra_rrhh_conc(p_conc_codi in number,
                                   p_conc_desc out varchar2) is

    begin
      select conc_desc
        into p_conc_desc
        from rrhh_conc
       where conc_codi = p_conc_codi;

    Exception
      when no_data_found then
        raise_application_error(-20010, 'Concepto Inexistente!');
      when others then
        raise_application_error(-20010, 'Error al buscar Concepto! ' || sqlerrm);
    end pp_muestra_rrhh_conc;

-----------------------------------------------
    procedure pp_muestra_empl(p_empl_codi in number, 
                              p_empl_desc out varchar2) is
      v_empl_esta varchar2(1);
    begin
      select empl_desc, empl_esta
        into p_empl_desc, v_empl_esta
        from come_empl
       where empl_codi = p_empl_codi;

    Exception
      when no_data_found then
        raise_application_error(-20010, 'Empleado Inexistente!');
      when others then
        raise_application_error(-20010, 'Error al buscar Empleado! ' || sqlerrm);
    end pp_muestra_empl;

-----------------------------------------------
    procedure pp_mostrar_caja_cuot(p_conc_codi in number,
                                   p_indi_caja out varchar2,
                                   p_indi_cuot out varchar2) is

    begin
      select c.conc_indi_caja, c.conc_indi_cuot
        into p_indi_caja, p_indi_cuot
        from rrhh_conc c
       where c.conc_codi = p_conc_codi;

    exception
      when others then
        raise_application_error(-20010, 'Error al buscar Caja! ' || sqlerrm);
    end pp_mostrar_caja_cuot;

-----------------------------------------------
  procedure pp_cargar_cheq(p_movi_codi in number) is
    
    cursor c_cabe is
      select c.cheq_codi,
             c.cheq_mone_codi,
             c.cheq_banc_codi,
             c.cheq_nume,
             c.cheq_serie,
             c.cheq_fech_emis,
             c.cheq_fech_venc,
             c.cheq_impo_mone,
             c.cheq_impo_mmnn,
             c.cheq_tipo,
             c.cheq_clpr_codi,
             c.cheq_esta,
             c.cheq_nume_cuen,
             c.cheq_obse,
             c.cheq_indi_ingr_manu,
             c.cheq_cuen_codi,
             c.cheq_tasa_mone,
             c.cheq_titu,
             c.cheq_orde,
             c.cheq_user,
             c.cheq_fech_grab,
             c.cheq_tach_codi,
             b.cuen_desc,
             ba.banc_desc,
             b.cuen_nume
      
        from come_movi_cheq ch,
             come_cheq      c,
             come_movi      m,
             come_cuen_banc b,
             come_banc      ba
      
       where c.cheq_codi = ch.chmo_cheq_codi
         and ch.chmo_movi_codi = m.movi_codi
         and c.cheq_cuen_codi = b.cuen_codi
         and c.cheq_banc_codi = ba.banc_codi
         and m.movi_rrhh_movi_codi = p_movi_codi;

  begin

    apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_bcheq);

    bcheq_emit.sum_cheq_impo_mone      := 0;
    bcheq_emit.sum_cheq_impo_mmnn      := 0;
    bcheq_emit.sum_cheq_impo_mone_movi := 0;
    
    for y in c_cabe loop
    
      bcheq_emit.cheq_mone_codi      := y.cheq_mone_codi;
      bcheq_emit.cheq_banc_codi      := y.cheq_banc_codi;
      bcheq_emit.cheq_nume           := y.cheq_nume;
      bcheq_emit.cheq_serie          := y.cheq_serie;
      bcheq_emit.s_cheq_fech_emis    := to_char(y.cheq_fech_emis,
                                                'dd/mm/yyyy');
      bcheq_emit.s_cheq_fech_venc    := to_char(y.cheq_fech_venc,
                                                'dd/mm/yyyy');
      bcheq_emit.cheq_tasa_mone      := y.cheq_tasa_mone;
      bcheq_emit.cheq_impo_mone      := y.cheq_impo_mone;
      bcheq_emit.cheq_impo_mmnn      := y.cheq_impo_mmnn;
      bcheq_emit.cheq_cuen_codi      := y.cheq_cuen_codi;
      bcheq_emit.cheq_nume_cuen      := y.cuen_nume;
      bcheq_emit.cheq_orde           := y.cheq_orde;
      bcheq_emit.cheq_cuen_desc      := y.cuen_desc;
      bcheq_emit.cheq_banc_desc      := y.banc_desc;
      bcheq_emit.cheq_impo_mone_movi := round((nvl(bcheq_emit.cheq_impo_mmnn, 0) / nvl(bcab.movi_tasa_mone, 1)), bcab.movi_mone_cant_deci);
    
      apex_collection.add_member(p_collection_name => parameter.collection_bcheq,
                                 p_c001            => bcheq_emit.cheq_mone_codi,
                                 p_c002            => bcheq_emit.cheq_banc_codi,
                                 p_c003            => bcheq_emit.cheq_nume,
                                 p_c004            => bcheq_emit.cheq_serie,
                                 p_c005            => bcheq_emit.s_cheq_fech_emis,
                                 p_c006            => bcheq_emit.s_cheq_fech_venc,
                                 p_c007            => bcheq_emit.cheq_tasa_mone,
                                 p_c008            => bcheq_emit.cheq_impo_mone,
                                 p_c009            => bcheq_emit.cheq_impo_mmnn,
                                 p_c010            => bcheq_emit.cheq_cuen_codi,
                                 p_c011            => bcheq_emit.cheq_nume_cuen,
                                 p_c012            => bcheq_emit.cheq_orde,
                                 p_c013            => bcheq_emit.cheq_cuen_desc,
                                 p_c014            => bcheq_emit.cheq_banc_desc,
                                 p_c015            => bcheq_emit.cheq_impo_mone_movi);
    
      bcheq_emit.sum_cheq_impo_mone      := bcheq_emit.sum_cheq_impo_mone + bcheq_emit.cheq_impo_mone;
      bcheq_emit.sum_cheq_impo_mmnn      := bcheq_emit.sum_cheq_impo_mmnn + bcheq_emit.cheq_impo_mmnn;
      bcheq_emit.sum_cheq_impo_mone_movi := bcheq_emit.sum_cheq_impo_mone_movi       + bcheq_emit.cheq_impo_mone_movi;
    
    end loop;

  end pp_cargar_cheq;

-----------------------------------------------
  procedure pp_calcular_importe_cab is
  begin

    if bcab.conc_indi_caja = 'S' then
      if bcab.movi_cond_pago = 'SE' then
        bcab.s_impo_cheq := 0;
        bcab.s_impo_efec := nvl(bcab.movi_impo_mone, 0);
        bcab.s_total     := nvl(bcab.s_impo_cheq, 0) + nvl(bcab.s_impo_efec, 0);
      
      elsif bcab.movi_cond_pago = 'SC' then
        bcab.s_impo_cheq := nvl(bcheq_emit.sum_cheq_impo_mone_movi, 0);
        bcab.s_impo_efec := 0;
        bcab.s_total     := nvl(bcab.s_impo_cheq, 0) + nvl(bcab.s_impo_efec, 0);
      
      elsif bcab.movi_cond_pago = 'EC' then
        bcab.s_impo_cheq := nvl(bcheq_emit.sum_cheq_impo_mone_movi, 0);
        bcab.s_impo_efec := nvl(bcab.movi_impo_mone, 0) - nvl(bcheq_emit.sum_cheq_impo_mone_movi, 0);
        if bcab.s_impo_efec < 0 then
          bcab.s_impo_efec := 0;
        end if;

        bcab.s_total := nvl(bcab.s_impo_cheq, 0) + nvl(bcab.s_impo_efec, 0);
      end if;
    end if;

  end pp_calcular_importe_cab;

-----------------------------------------------
  procedure pp_traer_saldo_cuot(p_cuot_movi_codi in number) is
  begin

    select nvl(sum(h.cuot_impo_mone), 0)
      into bcuo_enc.s_cuot_sald
      from rrhh_movi_cuot_deta h
     where h.cuot_movi_codi = p_cuot_movi_codi
       and cuot_liqu_codi is null;

  exception
    when others then
      raise_application_error(-20010, 'Error al calcular saldo cuota! ' || sqlerrm);
  end pp_traer_saldo_cuot;

-----------------------------------------------
  procedure pp_cargar_cuotas(p_movi_codi in number) is

    cursor c_cuot is
      select d.cuot_movi_codi,
             d.cuot_nume_item,
             d.cuot_fech_venc,
             d.cuot_impo_mone,
             d.cuot_impo_mmnn,
             d.cuot_nume
        from rrhh_movi_cuot_deta d
       where d.cuot_movi_codi = p_movi_codi
         and CUOT_LIQU_CODI is null;

    v_aux   number := 0;
    v_aux_2 number := 0;
    v_aux_3 number := 1;

  begin

    apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_bcuota);
    bcuota.dif := 0;
    
    bcuota.s_total_cuotas := 0;

    for y in c_cuot loop
      
    --raise_application_error(-20010, 'y.cuot_movi_codi: ' || y.cuot_movi_codi);
    
      v_aux_2 := v_aux_2 + 1;
      
      
      /*if v_aux_2 = 1 then
        pp_traer_saldo_cuot(y.cuot_movi_codi);
      end if;*/
      
      v_aux                 := 1;
      bcuota.cuot_nume      := y.cuot_nume;
      bcuota.cuot_nume_item := y.cuot_nume_item;
    
      if v_aux_3 = 1 then
        parameter.p_max_nume_item := y.cuot_nume;
      end if;
    
      bcuota.cuot_fech_venc   := y.cuot_fech_venc;
      bcuota.CUOT_FECH_ORIG   := y.cuot_fech_venc;
      bcuota.CUOT_IMPO_ORIG   := y.cuot_impo_mone;
      bcuota.s_cuot_fech_venc := y.cuot_fech_venc;--to_char(y.cuot_fech_venc, 'dd-mm-yyyy');
      bcuota.cuot_impo_mone   := y.cuot_impo_mone;
      bcuota.cuot_impo_mmnn   := y.cuot_impo_mmnn;
    
      v_aux_3 := v_aux_3 + 1;
      
      bcuota.s_total_cuotas := bcuota.s_total_cuotas + bcuota.cuot_impo_mone;
    
      apex_collection.add_member(p_collection_name => parameter.collection_bcuota,
                                 p_c001            => bcuota.cuot_fech_venc,
                                 p_c002            => bcuota.cuot_fech_orig,
                                 p_c003            => bcuota.cuot_impo_orig,
                                 p_c004            => bcuota.s_cuot_fech_venc,
                                 p_c005            => bcuota.cuot_impo_mone,
                                 p_c006            => bcuota.cuot_impo_mmnn,
                                 p_c007            => bcuota.cuot_nume,
                                 p_c008            => bcuota.cuot_nume_item,
                                 p_c009            => y.cuot_movi_codi
                                 );
    
    end loop;
    
    pp_traer_saldo_cuot(p_movi_codi);
    
    bcuota.dif := nvl(bcuo_enc.s_cuot_sald,0) - nvl(bcuota.s_total_cuotas,0);

    if v_aux = 1 then
      parameter.p_indi_carg_cuot := 's';
    else
      parameter.p_indi_carg_cuot := 'n';
    end if;

  end pp_cargar_cuotas;

-----------------------------------------------
  procedure pp_validar_importes is
  begin

    if bcab.conc_indi_caja = 'S' then
      if bcab.movi_cond_pago = 'SE' then
        if nvl(bcab.s_impo_efec, 0) <> nvl(bcab.movi_impo_mone, 0) then
          raise_application_error(-20010, 'El importe Total en Efectivo debe ser igual al importe del documento');
        end if;
      
        if nvl(bcab.s_impo_cheq, 0) <> 0 then
          raise_application_error(-20010, 'El importe de cheques debe ser igual a cero');
        end if;
      elsif bcab.movi_cond_pago = 'SC' then
        if nvl(bcab.s_impo_cheq, 0) <> nvl(bcab.movi_impo_mone, 0) then
          raise_application_error(-20010, 'El importe Total en Cheque/s debe ser igual al importe del documento');
        end if;
      
        if nvl(bcab.s_impo_efec, 0) <> 0 then
          raise_application_error(-20010, 'El importe de cheques debe ser igual a cero');
        end if;
      elsif bcab.movi_cond_pago = 'EC' then
      
        if (nvl(bcab.s_impo_cheq, 0) + nvl(bcab.s_impo_efec, 0)) <>
           nvl(bcab.movi_impo_mone, 0) then
        
          raise_application_error(-20010, 'La suma de los importes en efectivo y cheques debe ser igual al importe total del documento');
        end if;
        if nvl(bcab.movi_impo_mone, 0) <> nvl(bcab.s_total, 0) then
          raise_application_error(-20010, 'La suma de los importes en efectivo y cheques debe ser igual al importe total del documento');
        end if;
      
        if nvl(bcab.s_impo_cheq, 0) >= nvl(bcab.movi_impo_mone, 0) then
          raise_application_error(-20010, 'El importe de cheque no puede ser mayor o igual al importe del documento');
        end if;
      
        if nvl(bcab.s_impo_efec, 0) <= 0 then
          raise_application_error(-20010, 'El importe en efectivo debe ser mayor a cero');
        end if;
      
        if nvl(bcab.s_impo_cheq, 0) <= 0 then
          raise_application_error(-20010, 'El importe en cheque/s debe ser mayor a cero');
        end if;
      
      end if;
    
    end if;

  end pp_validar_importes;

-----------------------------------------------
  procedure pp_ejecutar_consulta_codi is
    v_movi_codi number;

  begin

    select movi_codi
      into v_movi_codi
      from rrhh_movi
     where movi_codi = bsel.s_codi
       and (bsel.s_empl_codi is null or movi_empl_codi                             = bsel.s_empl_codi)
       and (bsel.s_fech      is null or movi_fech_emis                             = bsel.s_fech)
       and (bsel.s_mes       is null or to_number(to_char(movi_fech_emis, 'mm'))   = (bsel.s_mes))
       and (bsel.s_anho      is null or to_number(to_char(movi_fech_emis, 'yyyy')) = (bsel.s_anho))
       and (bsel.s_nume      is null or movi_nume                                  = bsel.s_nume);

    --go_block('bcab');
    --set_block_property('bcab',default_where, 'movi_codi = '||to_char(v_movi_codi));
    --rrhh_movi
    --clear_block(no_validate) ;
    --Execute_query;

    --go_block('bpie');


    if v_movi_codi is not null then
      select movi_codi,
             movi_nume,
             movi_conc_codi,
             movi_fech_emis,
             movi_empl_codi,
             movi_mone_codi,
             movi_tasa_mone,
             movi_impo_mone,
             movi_cond_pago,
             movi_obse,
             movi_fech_grab,
             movi_user
        into bcab.movi_codi,
             bcab.movi_nume,
             bcab.movi_conc_codi,
             bcab.movi_fech_emis,
             bcab.movi_empl_codi,
             bcab.movi_mone_codi,
             bcab.movi_tasa_mone,
             bcab.movi_impo_mone,
             bcab.movi_cond_pago,
             bcab.movi_obse,
             bcab.movi_fech_grab,
             bcab.movi_user
        from rrhh_movi
       where movi_codi = to_char(v_movi_codi);
    
      --pp_calcular_importe_cab;
    
      if bcab.movi_mone_codi is not null then
        pp_mostrar_come_mone(bcab.movi_mone_codi,
                             bcab.movi_mone_desc_abre,
                             bcab.movi_mone_cant_deci,
                             bcab.movi_mone_desc);
      else
        bcab.movi_mone_cant_deci := 0;
      end if;
    
      if bcab.movi_conc_codi is not null then
        pp_muestra_rrhh_conc(bcab.movi_conc_codi, bcab.conc_desc);
      end if;
    
      if bcab.movi_empl_codi is not null then
        pp_muestra_empl(bcab.movi_empl_codi, bcab.empl_desc);
      end if;
    
      if bcab.movi_fech_emis is not null then
        bcab.s_movi_fech_emis := to_char(bcab.movi_fech_emis, 'dd/mm/yyyy');
      end if;
    
      pp_mostrar_caja_cuot(bcab.movi_conc_codi,
                           bcab.conc_indi_caja,
                           bcab.conc_indi_cuot);

      pp_cargar_cheq(bcab.movi_codi);      
      pp_cargar_cuotas(bcab.movi_codi);
/*
      PP_HAB_DESH_CUOTAS(parameter.p_indi_carg_cuot);
      go_block ('bpie');
      go_item ('cuotas');
*/      
      pp_calcular_importe_cab;
      pp_validar_importes;
/*      
      pp_hab_desh_cheque(:bcab.movi_cond_pago);
      pp_hab_desh_caja(:bcab.conc_indi_caja);
*/
      
      --ultimo
      parameter.p_movi_codi := null;
      parameter.p_movi_nume := null;
    
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Movimiento Inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Existen dos facturas con el mismo Codigo, aviste a su administrador');
      --no deberia entrar ak..... 
    when others then
      raise_application_error(-20010, 'Error al consultar documento! ' || sqlerrm);
    
  end pp_ejecutar_consulta_codi;

-----------------------------------------------
  procedure pp_ejecutar_consulta_nume is
    
    v_movi_codi number;
    
  begin

    select movi_codi
      into v_movi_codi
      from rrhh_movi, rrhh_conc
    
     where movi_conc_codi = conc_codi
       and movi_conc_codi = 4
       and (bsel.s_empl_codi is null or movi_empl_codi                             = bsel.s_empl_codi)
       and (bsel.s_fech      is null or movi_fech_emis                             = bsel.s_fech)
       and (bsel.s_mes       is null or to_number(to_char(movi_fech_emis, 'mm'))   = (bsel.s_mes))
       and (bsel.s_anho      is null or to_number(to_char(movi_fech_emis, 'yyyy')) = (bsel.s_anho))
       and (bsel.s_nume      is null or movi_nume                                  = bsel.s_nume);

    /*
    go_block('bcab');
    set_block_property('bcab',default_where, 'movi_codi = '||to_char(v_movi_codi));
    clear_block(no_validate) ;
    Execute_query; 
    go_block('bpie');
    go_item('cuotas');
    */

    if v_movi_codi is not null then
      select movi_codi,
             movi_nume,
             movi_conc_codi,
             movi_fech_emis,
             movi_empl_codi,
             movi_mone_codi,
             movi_tasa_mone,
             movi_impo_mone,
             movi_cond_pago,
             movi_obse,
             movi_fech_grab,
             movi_user
        into bcab.movi_codi,
             bcab.movi_nume,
             bcab.movi_conc_codi,
             bcab.movi_fech_emis,
             bcab.movi_empl_codi,
             bcab.movi_mone_codi,
             bcab.movi_tasa_mone,
             bcab.movi_impo_mone,
             bcab.movi_cond_pago,
             bcab.movi_obse,
             bcab.movi_fech_grab,
             bcab.movi_user
        from rrhh_movi
       where movi_codi = to_char(v_movi_codi);
    
      --pp_calcular_importe_cab;
    
      if bcab.movi_mone_codi is not null then
        pp_mostrar_come_mone(bcab.movi_mone_codi,
                             bcab.movi_mone_desc_abre,
                             bcab.movi_mone_cant_deci,
                             bcab.movi_mone_desc);
      else
        bcab.movi_mone_cant_deci := 0;
      end if;
    
      if bcab.movi_conc_codi is not null then
        pp_muestra_rrhh_conc(bcab.movi_conc_codi, bcab.conc_desc);
      end if;
    
      if bcab.movi_empl_codi is not null then
        pp_muestra_empl(bcab.movi_empl_codi, bcab.empl_desc);
      end if;
    
      if bcab.movi_fech_emis is not null then
        bcab.s_movi_fech_emis := to_char(bcab.movi_fech_emis, 'dd/mm/yyyy');
      end if;
    
      pp_mostrar_caja_cuot(bcab.movi_conc_codi,
                           bcab.conc_indi_caja,
                           bcab.conc_indi_cuot);
    
      pp_cargar_cheq(bcab.movi_codi);
      pp_calcular_importe_cab;
      pp_validar_importes;
    
      parameter.p_movi_codi := null;
      parameter.p_movi_nume := null;
    
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Movimiento Inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Existen dos Movimientos con el mismo numero, aviste a su administrador');
      --aca deberia consultar todos los ajustes con el mismo nro..
    when others then
      raise_application_error(-20010, 'Error al consultar documento! ' || sqlerrm);
    
  end pp_ejecutar_consulta_nume;

-----------------------------------------------
  procedure pp_send_item is
    
  begin
    
    --SETITEM('', bcab.);
    SETITEM('P72_MOVI_NUME',        bcab.movi_nume);
    SETITEM('P72_MOVI_CODI',        bcab.movi_codi);
    SETITEM('P72_MOVI_CONC_CODI',   bcab.movi_conc_codi);
    SETITEM('P72_MOVI_CONC_DESC',   bcab.movi_conc_codi ||' - '|| bcab.conc_desc);
    SETITEM('P72_S_MOVI_FECH_EMIS', bcab.s_movi_fech_emis);
    SETITEM('P72_MOVI_EMPL_CODI',   bcab.movi_empl_codi);
    SETITEM('P72_MOVI_EMPL_DESC',   bcab.movi_empl_codi||' - '||bcab.empl_desc);
    SETITEM('P72_MOVI_MONE_CODI',   bcab.movi_mone_codi);
    SETITEM('P72_MOVI_MONE_DESC',   bcab.movi_mone_codi||' - '||bcab.movi_mone_desc);
    SETITEM('P72_MOVI_MONE_DESC_ABRE', bcab.movi_mone_desc_abre);
    SETITEM('P72_MOVI_TASA_MONE',   bcab.movi_tasa_mone);
    SETITEM('P72_MOVI_IMPO_MONE',   bcab.movi_impo_mone);
    SETITEM('P72_MOVI_COND_PAGO',   bcab.movi_cond_pago);
    SETITEM('P72_MOVI_OBSE',        bcab.movi_obse);
    SETITEM('P72_S_IMPO_EFEC',      bcab.s_impo_efec);
    SETITEM('P72_S_IMPO_CHEQ',      bcab.s_impo_cheq);
    SETITEM('P72_S_TOTAL',          bcab.s_total);
    SETITEM('P72_MOVI_MONE_CANT_DECI', bcab.movi_mone_cant_deci);
    SETITEM('P72_MAX_NUME_ITEM',       parameter.p_max_nume_item);
    SETITEM('P72_P_INDI_REFI',         parameter.p_indi_refi);
    
    SETITEM('P72_HAB_DESH_CUOTAS',  parameter.p_hab_desh_cuotas);
    SETITEM('P72_HAB_DESH_CHEQUE',  parameter.p_hab_desh_cheque);
    SETITEM('P72_HAB_DESH_CAJA',    parameter.p_hab_desh_caja);
    
    SETITEM('P72_SALDO',            bcuota.dif);
    SETITEM('P72_S_CUOT_SALD',      bcuo_enc.s_cuot_sald);
    
    
  end;
    
-----------------------------------------------
  procedure pp_muestra_cuen_banc(p_cuen_codi in number,
                                 p_cuen_desc out varchar2) is

  begin
    select cuen_desc
      into p_cuen_desc
      from come_cuen_banc
     where cuen_codi = p_cuen_codi;

  Exception
    when no_data_found then
      raise_application_error(-20010, 'Cuenta Bancaria Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar Cuenta Bancaria! ' || sqlerrm);
  end pp_muestra_cuen_banc;

-----------------------------------------------
  procedure pp_cargar_impo_deta(p_movi_codi in number) is
    cursor c_impo is
      select d.moim_movi_codi,
             d.moim_nume_item,
             d.moim_tipo,
             d.moim_cuen_codi,
             decode(d.moim_dbcr, 'C', 'Credito', 'D', 'Debito') moim_dbcr,
             d.moim_afec_caja,
             d.moim_fech,
             d.moim_impo_mone,
             d.moim_impo_mmnn
        from come_movi_impo_deta d, come_movi m
       where d.moim_movi_codi = m.movi_codi
         and m.movi_rrhh_movi_codi = p_movi_codi;

  begin

    --cargar importe solamente si tiene paga en efectivo

    apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_bcaja);

    for y in c_impo loop
      --bcaja.moim_movi_codi                := y.moim_movi_codi;
      --bcaja.moim_nume_item                := y.moim_nume_item;
      bcaja.moim_tipo      := y.moim_tipo;
      bcaja.moim_cuen_codi := y.moim_cuen_codi;
      bcaja.moim_dbcr      := y.moim_dbcr;
      --bcaja.moim_afec_caja                := y.moim_afec_caja;
      --bcaja.moim_fech                     := y.moim_fech;
    
      if bcaja.moim_dbcr = 'D' then
        bcaja.moim_impo_mone_db := y.moim_impo_mone;
        bcaja.moim_impo_mone_cr := 0;
      else
        bcaja.moim_impo_mone_cr := y.moim_impo_mone;
        bcaja.moim_impo_mone_db := 0;
      end if;
    
      bcaja.moim_impo_mmnn := y.moim_impo_mmnn;
      bcaja.s_neto         := nvl(bcaja.moim_impo_mone_db, 0) -
                              nvl(bcaja.moim_impo_mone_cr, 0);
    
      pp_muestra_cuen_banc(bcaja.moim_cuen_codi, bcaja.moim_cuen_desc);
    
      apex_collection.add_member(p_collection_name => parameter.collection_bcaja,
                                 p_c001            => bcaja.moim_tipo,
                                 p_c002            => bcaja.moim_cuen_codi,
                                 p_c003            => bcaja.moim_dbcr,
                                 p_c004            => bcaja.moim_impo_mone_db,
                                 p_c005            => bcaja.moim_impo_mone_cr,
                                 p_c006            => bcaja.moim_impo_mmnn,
                                 p_c007            => bcaja.s_neto,
                                 p_c008            => bcaja.moim_cuen_desc);
    
    end loop;

  end pp_cargar_impo_deta;
  
-----------------------------------------------
  procedure PP_HAB_DESH_CUOTAS(p_indi in varchar2) is

  begin

    if upper(p_indi) = 'S' then -- entonces habilitar
      parameter.p_hab_desh_cuotas := p_indi;
    elsif upper(p_indi) = 'N' then -- entonces deshabilitar
      parameter.p_hab_desh_cuotas := p_indi;
    end if;

  end PP_HAB_DESH_CUOTAS;

-----------------------------------------------
  procedure pp_hab_desh_cheque(p_indi in varchar2) is
  begin

    if p_indi in ('SC', 'EC') then -- entonces habilitar
      parameter.p_hab_desh_cheque:= 'S';
    elsif p_indi = 'SE' then -- entonces deshabilitar
      parameter.p_hab_desh_cheque:= 'N';
    end if;

  end pp_hab_desh_cheque;

-----------------------------------------------
  procedure pp_hab_desh_caja(p_indi in varchar2) is

  begin

    if p_indi = 'S' then -- entonces habilitar
      parameter.p_hab_desh_caja := 'S';
    elsif p_indi = 'N' then --entonces deshabilitar
      parameter.p_hab_desh_caja := 'N';
    end if;

  end pp_hab_desh_caja;

-----------------------------------------------
  procedure pp_ejecutar_consulta(s_codi      varchar2,
                                 s_empl_codi number,
                                 s_fech      varchar2,
                                 s_mes       number,
                                 s_anho      number,
                                 s_nume      number
                                 ) is
    
  begin
    
                                 
    if s_nume is null and s_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar un documento! ');
    end if;
    
    bsel.s_codi      := s_codi;
    bsel.s_empl_codi := s_empl_codi;
    bsel.s_fech      := s_fech;
    bsel.s_mes       := s_mes;
    bsel.s_anho      := s_anho;
    bsel.s_nume      := s_nume;
    
    if bsel.s_codi is not null then 
      pp_ejecutar_consulta_codi;
      pp_cargar_cuotas(bcab.movi_codi);
      
      pp_hab_desh_cuotas(parameter.p_indi_carg_cuot);
      pp_hab_desh_cheque(bcab.movi_cond_pago);
      pp_hab_desh_caja(bcab.conc_indi_caja);
      
      if parameter.p_hab_desh_cuotas = 'S' then
        pp_cargar_cuotas(bcab.movi_codi);
      end if;
      
      pp_send_item;
    else
      pp_ejecutar_consulta_nume;
      pp_cargar_cuotas(bcab.movi_codi);
      
      pp_hab_desh_cuotas(parameter.p_indi_carg_cuot);
      pp_hab_desh_cheque(bcab.movi_cond_pago);
      pp_hab_desh_caja(bcab.conc_indi_caja);
      
      if parameter.p_hab_desh_cuotas = 'S' then
        pp_cargar_cuotas(bcab.movi_codi);
      end if;
      
      pp_send_item;
    end if;
    
    /*
    if parameter.p_hab_desh_cuotas = 'S' then
      pp_cargar_cuotas(bcab.movi_codi);
    end if;*/
    
    if parameter.p_hab_desh_cheque = 'S' then
      pp_cargar_cheq(bcab.movi_codi);
    end if;
    
    if parameter.p_hab_desh_caja = 'S' then
      pp_cargar_impo_deta (bcab.movi_codi);
    end if;
    
    /*
    PP_HAB_DESH_CUOTAS(:parameter.p_indi_carg_cuot);
    go_block ('bpie');
    go_item ('cuotas');
    pp_calcular_importe_cab;
    pp_validar_importes;
    */    
    
    
  end pp_ejecutar_consulta;

-----------------------------------------------
  procedure pp_validar_update_cuot(i_movi_codi      in number,
                                   i_movi_fech_emis in date,
                                   i_cuot_fech_venc in date,
                                   i_cuot_nume_item in number
                                   
                                   ) is
                                   
   cursor c_bcuota is
     select det.seq_id nro,
         c001     cuot_fech_venc,
         c002     cuot_fech_orig,
         c003     cuot_impo_orig,
         c004     s_cuot_fech_venc,
         c005     cuot_impo_mone,
         c006     cuot_impo_mmnn,
         c007     cuot_nume,
         c008     cuot_nume_item
     from apex_collections det
    where det.collection_name = 'COLL_BCUOTA';

    
    v_fech_inic date;
    v_cont      number := 0;
    v_aux       number := 0;
    
  begin
    
    
    bcab.movi_codi      := i_movi_codi;
    bcab.movi_fech_emis := i_movi_fech_emis;

    select a.peri_fech_inic
      into v_fech_inic
      from rrhh_peri a
     where a.peri_codi = parameter.p_codi_peri_actu_rrhh;
     
                                         
    for y in c_bcuota loop
      
      --if y.cuot_fech_venc <> y.cuot_fech_orig then
      if i_cuot_fech_venc <> y.cuot_fech_orig then
        
        select nvl(count(*), 0)
          into v_cont
          from rrhh_movi_cuot_deta d
         where d.cuot_movi_codi = bcab.movi_codi
           and d.cuot_fech_venc = i_cuot_fech_venc--y.cuot_fech_venc
           and d.cuot_nume_item <> i_cuot_nume_item;--y.cuot_nume_item;
      
        if v_cont >= 1 then
          raise_application_error(-20010, 'Fecha de Vcto. coincide con otra cuota');
        end if;
      
        --if y.cuot_fech_venc < bcab.movi_fech_emis then
        if i_cuot_fech_venc < bcab.movi_fech_emis then
          raise_application_error(-20010, 'La fecha de Venc. no puede ser menor a la Fecha de Emision');
        end if;
      
        if v_aux < 1 then
          --if y.cuot_fech_venc < v_fech_inic then
          if i_cuot_fech_venc < v_fech_inic then
            v_aux := 1;
            raise_application_error(-20010, 'Hay fechas que se corresponden periodo cerrado!');
          end if;
        end if;
        
      end if;

    end loop;


    /*if :bpie_cuota.saldo <> 0 then
      pl_me('La diferencia debe quedar en  0!!');
    end if;*/
    
  end pp_validar_update_cuot;
     
-----------------------------------------------
  procedure pp_update_cuotas(i_seq              in number,
                             i_cuot_fech_venc   in date,
                             i_cuot_fech_orig   in date,
                             i_cuot_impo_orig   in number,
                             i_fech_venc        in date,
                             i_cuot_impo_mone   in number,
                             i_cuot_impo_mmnn   in number,
                             i_cuot_nume        in number,
                             i_cuot_nume_item   in number,
                             i_movi_codi        in number,
                             i_movi_fech_emis   in date,
                             i_s_cuot_sald      in  number,
                             i_cuot_movi_codi   in number,
                             o_dif              out number,
                             o_indi_refi        out varchar2
                             
                             ) is
    
    v_total_cuotas number:=0;
    
  begin
    
    if i_fech_venc is null then
      raise_application_error(-20010, 'La fecha de vencimiento no puede quedar en blanco!');
    end if;  
    
     if i_cuot_impo_mone is null then
      raise_application_error(-20010, 'El importe no puede quedar en blanco!');
    end if;  
    
    pp_validar_update_cuot(i_movi_codi,
                           i_movi_fech_emis,
                           i_fech_venc,
                           i_cuot_nume_item);
  
    APEX_COLLECTION.UPDATE_MEMBER (
        p_collection_name => parameter.collection_bcuota,
        p_seq  => i_seq,
        p_c001 => i_fech_venc,--i_cuot_fech_venc,
        p_c002 => i_fech_venc,--i_cuot_fech_orig,
        p_c003 => i_cuot_impo_mone,--i_cuot_impo_orig,
        p_c004 => i_fech_venc,
        p_c005 => i_cuot_impo_mone,--i_cuot_impo_orig,--i_cuot_impo_mone,
        p_c006 => i_cuot_impo_mone,--i_cuot_impo_orig,--i_cuot_impo_mone,--i_cuot_impo_mmnn,
        p_c007 => i_cuot_nume,
        p_c008 => i_cuot_nume_item,
        p_c009 => i_cuot_movi_codi
        );
        
    select nvl(sum(to_number(c005)),0)
       into v_total_cuotas
      from apex_collections det
     where det.collection_name = 'COLL_BCUOTA';
 
    o_dif := nvl(i_s_cuot_sald,0) - nvl(v_total_cuotas,0);
    parameter.p_indi_refi := 'I';
    
    o_indi_refi := parameter.p_indi_refi;
        
  end pp_update_cuotas;

-----------------------------------------------
  procedure pp_delete_cuotas(i_seq         in number,
                             i_s_cuot_sald in  number,
                             o_dif         out number
                             ) is
    
    v_total_cuotas number:=0;
  
  begin
    
    if i_seq is null then
      raise_application_error(-20010, 'No se ha seleccionado ningun registro!');
    end if;
    
    APEX_COLLECTION.DELETE_MEMBER(
        p_collection_name => parameter.collection_bcuota,
        p_seq => i_seq);
        
      select nvl(sum(to_number(c005)),0)
         into v_total_cuotas
        from apex_collections det
       where det.collection_name = 'COLL_BCUOTA';
 
      o_dif := nvl(i_s_cuot_sald,0) - nvl(v_total_cuotas,0);
    
  end pp_delete_cuotas;
  
-----------------------------------------------
  procedure pp_borrar_cuotas(i_movi_codi in number) is
  begin

    apex_collection.delete_members(p_collection_name => parameter.collection_bcuota,
                                   p_attr_number     => 9,
                                   p_attr_value      => i_movi_codi);
    commit;

    /*delete rrhh_movi_cuot_deta
    where cuot_movi_codi = :bcab.movi_codi
    and cuot_liqu_codi is null;*/

  end pp_borrar_cuotas;

-----------------------------------------------
  procedure pp_refinanciar_cuotas(i_s_dias_entre_cuotas in number,
                                  i_fec_prim_vto        in date,
                                  i_cant_cuotas         in number,
                                  i_s_tipo_vencimiento  in varchar2,
                                  i_movi_mone_cant_deci in number,
                                  i_movi_tasa_mone      in number,
                                  i_s_cuot_sald         in number,
                                  i_cuot_movi_codi      in number,
                                  o_dif                 out number
                                  ) is
    
    v_dias           number;
    v_importe        number;
    v_cant_cuotas    number;
    v_entrega        number := 0;
    v_vto            number;
    v_diferencia     number;
    v_count          number := 0;
    v_cuot_fech_venc date;

  begin
    
    bcuo_enc.s_dias_entre_cuotas := i_s_dias_entre_cuotas ;
    bcuo_enc.fec_prim_vto        := i_fec_prim_vto ;
    bcuo_enc.cant_cuotas         := i_cant_cuotas ;
    bcuo_enc.s_tipo_vencimiento  := i_s_tipo_vencimiento ;
    
    bcab.movi_mone_cant_deci     := i_movi_mone_cant_deci ;
    bcab.movi_tasa_mone          := i_movi_tasa_mone ;
    
    v_vto            := bcuo_enc.s_dias_entre_cuotas;
    v_dias           := v_vto;
    v_cuot_fech_venc := bcuo_enc.fec_prim_vto;
    v_entrega        := 0;
    v_cant_cuotas    := bcuo_enc.cant_cuotas;
    v_importe        := round(i_s_cuot_sald / v_cant_cuotas, nvl(bcab.movi_mone_cant_deci, 0));
    v_diferencia     := (i_s_cuot_sald - (v_importe * v_cant_cuotas));


    v_count                    := parameter.p_max_nume_item;
    
    for x in 1 .. v_cant_cuotas loop
      bcuota.dias             := v_dias;
      bcuota.cuot_impo_mone   := v_importe;
      bcuota.cuot_impo_mmnn   := round(v_importe * bcab.movi_tasa_mone, 0);
      bcuota.cuot_fech_venc   := v_cuot_fech_venc;
      bcuota.s_cuot_fech_venc := to_char(bcuota.cuot_fech_venc, 'dd/mm/yyyy');
      --bcuota.indi_refi        := 'N';
      v_dias                        := v_dias + v_vto;
      
      --pl_mm(v_count);
      bcuota.cuot_nume      := v_count;
      bcuota.cuot_nume_item := v_count;
      --bcuota.cuot_nume        := to_number(:system.cursor_record);
      v_count                := v_count + 1;
      if bcuo_enc.s_tipo_vencimiento = 'V' then
        v_cuot_fech_venc := v_cuot_fech_venc + v_vto;
      else
        v_cuot_fech_venc := add_months(v_cuot_fech_venc, 1);
      end if;
      
      apex_collection.add_member(p_collection_name => parameter.collection_bcuota,
                                 p_c001            => bcuota.cuot_fech_venc,
                                 --p_c002            => bcuota.cuot_fech_orig,
                                 --p_c003            => bcuota.cuot_impo_orig,
                                 p_c004            => bcuota.s_cuot_fech_venc,
                                 p_c005            => bcuota.cuot_impo_mone,
                                 p_c006            => bcuota.cuot_impo_mone,--bcuota.cuot_impo_mmnn,
                                 p_c007            => bcuota.cuot_nume,
                                 p_c008            => bcuota.cuot_nume_item,
                                 p_c009            => i_cuot_movi_codi
                                 );
    
    end loop;

    ---------------------
    if v_diferencia <> 0 then
      --sumar la diferencia a la ultima cuota   
      bcuota.cuot_impo_mone := bcuota.cuot_impo_mone + v_diferencia;
    end if;
    
    parameter.p_indi_refi := 'S';

  end pp_refinanciar_cuotas;

-----------------------------------------------
  procedure pp_redefinir_cuotas(i_cant_cuotas         in number,
                                i_s_tipo_vencimiento  in varchar2,
                                i_s_fec_prim_vto      in date,
                                i_s_dias_entre_cuotas in number,
                                i_s_movi_fech_emis    in date, --bcab
                                i_movi_codi           in number, --bcab
                                i_movi_mone_cant_deci in number,
                                i_movi_tasa_mone      in number,
                                i_s_cuot_sald         in number,
                                i_max_nume_item       in number,
                                o_dif                 out number,
                                i_indi_refi           out varchar2
                                ) is
    
  begin
    
    -- 
    if i_cant_cuotas is null then
      raise_application_error(-20010,'Debe ingresar un valor valido para la Cantidad de Cuotas!');
    end if;
    if i_s_tipo_vencimiento is null then
      raise_application_error(-20010,'Debe ingresar un valor valido para el Tipo de Vencimiento!');
    end if;
    if i_s_fec_prim_vto is null then
      raise_application_error(-20010,'Debe ingresar un valor valido para el Primer Vto.');
    end if;
    if i_s_dias_entre_cuotas is null then
      raise_application_error(-20010,'Debe ingresar un valor valido para los Dias entre Cuotas!');
    end if;
    if i_s_movi_fech_emis is null then
      raise_application_error(-20010,'Debe ingresar un valor valido para la Fecha de Emision!');
    end if;
   -- 
   
    if i_cant_cuotas < 1 then
      raise_application_error(-20010,'No puede ingresar una catidad menor a 1 cuota');
    end if;
    if nvl(i_s_tipo_vencimiento,' ') not in ('F','V') then
      raise_application_error(-20010,'Debe ser Fijo o Variable!');
    end if;
    if i_s_fec_prim_vto < i_s_movi_fech_emis then
     raise_application_error(-20010,'La fecha de vecimiento no puede ser menor a la fecha del documento');
    end if;
    
    parameter.p_max_nume_item := i_max_nume_item;
    
    pp_borrar_cuotas(i_movi_codi);
    --post;
    pp_refinanciar_cuotas(i_s_dias_entre_cuotas,
                          i_s_fec_prim_vto,
                          i_cant_cuotas,
                          i_s_tipo_vencimiento,
                          i_movi_mone_cant_deci,
                          i_movi_tasa_mone,
                          i_s_cuot_sald,
                          i_movi_codi,
                          o_dif
                          );
    
    i_indi_refi := parameter.p_indi_refi;
    
  end pp_redefinir_cuotas;
  
-----------------------------------------------
  procedure pp_actu_venc_cuot is

    v_cuot_movi_codi      number;
    v_cuot_nume_item      number;
    v_cuot_fech_venc      date;
    v_cuot_impo_mone      number;
    v_cuot_impo_mmnn      number;
    v_cuot_nume           number;
    v_cuot_base           number;
    v_cuot_impo_mone_liqu number;

    e_update exception;

    cursor c_bcuota is
      select det.seq_id nro,
             c001       cuot_fech_venc,
             c002       cuot_fech_orig,
             c003       cuot_impo_orig,
             c004       s_cuot_fech_venc,
             c005       cuot_impo_mone,
             c006       cuot_impo_mmnn,
             c007       cuot_nume,
             c008       cuot_nume_item
        from apex_collections det
       where det.collection_name = 'COLL_BCUOTA';

  begin

    if parameter.p_indi_refi = 'S' then
      delete rrhh_movi_cuot_deta
      where cuot_movi_codi = bcab.movi_codi
      and cuot_liqu_codi is null;
    end if;
    
    
    
    for bcuota in c_bcuota loop
    
      if parameter.p_indi_refi = 'I' then
        update rrhh_movi_cuot_deta
                 set cuot_fech_venc      = bcuota.cuot_fech_venc,
                     cuot_impo_mone      = bcuota.cuot_impo_mone,
                     cuot_impo_mmnn      = bcuota.cuot_impo_mmnn,
                     cuot_impo_mone_liqu = bcuota.cuot_impo_mone
               where cuot_movi_codi = bcab.movi_codi
                 and cuot_nume_item = bcuota.cuot_nume_item;
        
        /*         
        raise_application_error(-20010, 'parameter.p_indi_refi: ' || parameter.p_indi_refi);
        
        --pl_mm('paso 1');
        if bcuota.cuot_nume_item is not null and bcab.movi_codi is not null then
          if bcuota.cuot_fech_venc is not null and
             bcuota.cuot_impo_mone is not null then
            if bcuota.cuot_fech_venc <> bcuota.cuot_fech_orig or
               bcuota.cuot_impo_mone <> bcuota.cuot_impo_orig then
              --        pl_mm('paso 2');
              update rrhh_movi_cuot_deta
                 set cuot_fech_venc      = bcuota.cuot_fech_venc,
                     cuot_impo_mone      = bcuota.cuot_impo_mone,
                     cuot_impo_mmnn      = bcuota.cuot_impo_mmnn,
                     cuot_impo_mone_liqu = bcuota.cuot_impo_mone
               where cuot_movi_codi = bcab.movi_codi
                 and cuot_nume_item = bcuota.cuot_nume_item;
            end if;
          end if;
        end if;
      */
      else
        --pl_mm('paso 3');
        
      
        v_cuot_movi_codi := bcab.movi_codi;
        v_cuot_nume_item := bcuota.cuot_nume_item;
        v_cuot_fech_venc := bcuota.cuot_fech_venc;
        v_cuot_impo_mone := bcuota.cuot_impo_mone;
        v_cuot_impo_mmnn := bcuota.cuot_impo_mmnn;
        v_cuot_nume      := bcuota.cuot_nume;
        --v_cuot_base           := :parameter.p_codi_base;
        v_cuot_impo_mone_liqu := bcuota.cuot_impo_mone;
        --pl_mm('cuot_nume_item '||v_cuot_nume_item);
        begin
          insert into rrhh_movi_cuot_deta
            (cuot_movi_codi,
             cuot_nume_item,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_impo_mmnn,
             cuot_nume,
             --cuot_base,
             cuot_impo_mone_liqu)
          values
            (v_cuot_movi_codi,
             v_cuot_nume_item,
             v_cuot_fech_venc,
             v_cuot_impo_mone,
             v_cuot_impo_mmnn,
             v_cuot_nume,
             --v_cuot_base,
             v_cuot_impo_mone_liqu);
        
        exception
          when others then
            raise e_update;
        end;
      
      end if;
    
    end loop;
    

  exception

    when e_update then
      raise_application_error(-20010, 'Ha ocurrido un error al momento de actualizar los registros modificados!');
    when others then
      raise_application_error(-20010, 'Error, registros no actualizados! ' || sqlerrm);
    
  end pp_actu_venc_cuot;


-----------------------------------------------
  procedure pp_actualizar_registro(i_indi_refi in varchar2,
                                   i_movi_codi in number,
                                   i_dif       in number
                                   ) is
    
  begin
    
    parameter.p_indi_refi:= i_indi_refi;
    bcab.movi_codi       := i_movi_codi;
    
    if nvl(parameter.p_indi_refi,'N') = 'N' then
      null;
      --raise_application_error(-20010,'No se ha modificado ningun registro');
    else
      if i_dif <> 0 then
        raise_application_error(-20010,'La diferencia debe quedar en  0!');
      end if;
    
      pp_actu_venc_cuot;
      apex_application.g_print_success_message :='Registro modificado correctamente!';
    end if;
    
  end pp_actualizar_registro;
  
-----------------------------------------------
  
  
end I020230;
