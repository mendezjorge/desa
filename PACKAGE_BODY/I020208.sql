
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020208" is

  type r_parameter is record(
       p_peco number := 1,
       p_codi_oper_inve_inic number := to_number(general_skn.fl_busca_parametro ('p_codi_oper_inve_inic')),
       p_codi_oper_com       number := to_number(general_skn.fl_busca_parametro ('p_codi_oper_com')),
       p_fech_inic           date,
       p_fech_fini           date,
       p_codi_mone_mmee      number := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmee')),
       p_codi_mone_mmnn      number := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),
       collection_name       varchar2(30):='INVENTARIO_DET',
       p_codi_base           number := 1,
       p_cant_deci_mmnn      number := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),
       p_cant_deci_mmee      number,
       P_EMPR_CODI           number := 1,
       p_codi_peri_actu number := general_skn.fl_busca_parametro('p_codi_peri_actu')

  );
  parameter r_parameter;

  type r_bcab is record(
       movi_codi                come_movi.movi_codi%type,
       movi_fech_grab           come_movi.movi_fech_grab%type,
       movi_user                come_movi.movi_user%type
  );

  bcab r_bcab; --come_movi%rowtype;

  cursor g_cursor_det is
  select det.seq_id nro,
         det.c001   DETA_PROD_CODI,
         det.c002   S_PRODUCTO_CF,
         det.c003   S_PRODUCTO_DESC,
         det.c004   DETA_CANT,
         det.c005   DETA_PREC_UNIT,
         det.c006   S_TOTAL,
         det.c007   PROD_INDI_LOTE,
         det.c008   DETA_IMPU_CODI,
         det.c009   DETA_LOTE_CODI,
         det.c010 DETA_GRAV10_II_MONE,
         det.c011 DETA_GRAV5_II_MONE,
         det.c012 DETA_EXEN_MONE
  from apex_collections det
  where det.collection_name = parameter.collection_name;

-----------------------------------------------
  procedure pp_buscar_nume(p_nume out number) is
  begin

    select (nvl(secu_nume_ajus, 0) + 1) nume
      into p_nume
      from come_secu s, come_pers_comp t
     where s.secu_codi = t.peco_secu_codi
       and t.peco_codi = parameter.p_peco;

  Exception
    When no_data_found then
      raise_application_error(-20010,'Codigo de Secuencia no fue correctamente asignada a la terminal');
    when others then
      raise_application_error(-20010,'Error al buscarel Nro. de Movimiento!. '|| sqlerrm);
  end;

-----------------------------------------------
  procedure pp_valida_nume(i_movi_nume in number) is
  v_count number;
  begin

    select count(*)
      into v_count
      from come_movi
     where movi_nume = i_movi_nume
       and movi_oper_codi in (parameter.p_codi_oper_inve_inic);

    if v_count > 0 then
      raise_application_error(-20010,'Nro de ajuste existente');
    end if;
  end pp_valida_nume;

-----------------------------------------------
  procedure pp_mostrar_operacion(i_movi_oper_codi            in number,
                                 i_movi_stoc_suma_rest       out varchar2,
                                 i_movi_stoc_afec_cost_prom  out varchar2) is
  begin

    --raise_application_error(-20010,'bcab.movi_oper_codi: '||v('P46_MOVI_OPER_CODI'));

    select oper_stoc_suma_rest, oper_stoc_afec_cost_prom
      into i_movi_stoc_suma_rest,--bcab.movi_stoc_suma_rest,
           i_movi_stoc_afec_cost_prom--bcab.movi_stoc_afec_cost_prom
      from come_stoc_oper
     where oper_codi = i_movi_oper_codi;--bcab.movi_oper_codi;

  exception
    when no_data_found then
      raise_application_error(-20010,'Operacion inexistente!. ');
    when others then
      raise_application_error(-20010,'Error al buscar operacion!');
  end;

-----------------------------------------------
  procedure pp_valida_fech(p_fech in date) is
  begin

    pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );

    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then

      raise_application_error(-20010,'La fecha del movimiento debe estar comprendida entre..' ||
            to_char(parameter.p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
            to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;

  exception
    when others then
      raise_application_error(-20010,'Error al validar la fecha!. '|| sqlerrm);
  end;

-----------------------------------------------
  procedure pp_busca_tasa_mmee (p_mone_codi in number,
                                i_movi_fech_emis in date,
                                p_mone_coti out number)is
  begin

    if parameter.p_codi_mone_mmnn = p_mone_codi then
       p_mone_coti := 1;
    else
      select coti_tasa
      into p_mone_coti
      from come_coti
      where coti_mone = p_mone_codi
      and trunc(coti_fech)   = trunc(i_movi_fech_emis)
      and coti_tica_codi = 2;
    end if;

    Exception
        When no_data_found then
          raise_application_error(-20010,'Cotizacion Inexistente para la moneda extranjera '||p_mone_codi||' ; '||i_movi_fech_emis );--||parameter.p_desc_mone_mmee);
        when others then
          raise_application_error(-20010,'Error al buscar la cotizacion!. '|| sqlerrm);

  end;
-----------------------------------------------
  procedure call_busca_tasa(i_movi_fech_emis in date,
                            p_mone_coti      out varchar2) is
   v_mone_cant_deci number;
   v_mone_coti      number;
  begin
    --pp_busca_tasa_mmee (parameter.p_codi_mone_mmee,p_mone_coti);
    pp_busca_tasa_mmee (parameter.p_codi_mone_mmee,
                        i_movi_fech_emis,
                        v_mone_coti);

    select mone_cant_deci
    into v_mone_cant_deci
    from come_mone
    where mone_codi = parameter.p_codi_mone_mmee;

    p_mone_coti:= fp_devu_mask(nvl(v_mone_cant_deci,0),v_mone_coti);

  end;

-----------------------------------------------
  procedure pp_muestra_come_depo(p_codi_depo in number,
                               p_codi_sucu out number,
                               p_desc_sucu out char) is

  begin

    select sucu_desc, sucu_codi
      into p_desc_sucu, p_codi_sucu
      from come_depo, come_sucu
     where depo_sucu_codi = sucu_codi
       and depo_codi = p_codi_depo;

  Exception
    when no_data_found then
      raise_application_error(-20010, 'Deposito inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar la sucursal!. ' || sqlerrm);
  end;

-----------------------------------------------
  procedure pl_muestra_come_mone(p_mone_codi      in number,
                               p_mone_desc_abre out char,
                               p_mone_cant_deci out number) is
  begin
    select mone_desc_abre, mone_cant_deci
      into p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;

    -- bcab.movi_mone_cant_deci := p_mone_cant_deci;

  Exception
    when no_data_found then
      raise_application_error(-20010, 'Moneda Inexistente!');

    when others then
      raise_application_error(-20010,
                              'Error al buscar detalles de la moneda!.' ||
                              sqlerrm);
  end;

-----------------------------------------------
  procedure pp_busca_tasa_mone (p_mone_codi in number,
                                i_movi_fech_emis in date,
                                p_mone_coti out number) is
  begin

    if parameter.p_codi_mone_mmnn = p_mone_codi then
       p_mone_coti := 1;
    else
      select coti_tasa
      into p_mone_coti
      from come_coti
      where coti_mone = p_mone_codi
      and coti_fech   = i_movi_fech_emis
      and coti_tica_codi = 2;
    end if;

    Exception
        When no_data_found then
          raise_application_error(-20010,'Cotizacion Inexistente para la fecha del documento');
        when others then
          raise_application_error(-20010,'Error al buscar la tasa!. '|| sqlerrm);

  end;

-----------------------------------------------
  procedure pp_calc_total_modal ( i_deta_cant           in number,
                                  i_deta_prec_unit      in varchar2,
                                  i_movi_mone_cant_deci in number,
                                  o_s_total             out number) is
    r_cant_deci exception;
    v_prec_unit number;

  begin

    if i_movi_mone_cant_deci is null then
      raise r_cant_deci;
    end if;

    select to_number(trim(replace(i_deta_prec_unit,'.','')))
    into v_prec_unit
    from dual;

    o_s_total := Round(nvl(i_deta_cant, 0) * nvl(v_prec_unit, 0), i_movi_mone_cant_deci);--bcab.movi_mone_cant_deci

  exception
    when r_cant_deci then
      raise_application_error(-20010, 'Debe de seleccionar primero una moneda!.');
    when others then
      raise_application_error(-20010, 'Error al calcular el total!.'|| sqlerrm);

  end;

-----------------------------------------------
  procedure pp_mostrar_producto(i_prod_codi_alfa  in number,
                               i_s_producto_desc out varchar2,
                               i_deta_prod_codi  out number,
                               i_prod_indi_lote  out varchar2,
                               i_deta_impu_codi  out number,
                               i_deta_lote_codi  out number) is
  v_ind_inactivo varchar2(1);
  begin
    --select prod_desc,prod_codi,nvl(prod_indi_inac, 'N'),nvl(prod_indi_lote, 'N'),prod_impu_codi
    select prod_desc,prod_codi_alfa,nvl(prod_indi_inac, 'N'),nvl(prod_indi_lote, 'N'),prod_impu_codi
      into i_s_producto_desc,
           i_deta_prod_codi,
           v_ind_inactivo,
           i_prod_indi_lote,
           i_deta_impu_codi
      from come_prod
     where prod_codi = i_prod_codi_alfa;
     --where prod_codi_alfa = i_prod_codi_alfa;

    if v_ind_inactivo = 'S' then
      raise_application_error(-20010,'El producto se encuentra inactivo');
    end if;

    if i_prod_indi_lote = 'N' then
      i_deta_lote_codi := null;
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010,'Producto inexistente!');
    when too_many_rows then
      raise_application_error(-20010,'Codigo duplicado');
    when others then
      raise_application_error(-20010,'Error al buscar detalles del producto!. '|| sqlerrm);
  end;

-----------------------------------------------
  PROCEDURE PP_CALCULAR_IMPORTE_ITEM(I_DETA_IMPU_CODI      in number,
                                   I_S_TOTAL             in number,
                                   I_MOVI_TASA_MONE      in number,
                                   I_MOVI_MONE_CANT_DECI in number,

                                   I_DETA_GRAV10_II_MONE out number,
                                   I_DETA_GRAV5_II_MONE  out number,
                                   I_DETA_EXEN_MONE      out number) IS

  V_IMPU_PORC                NUMBER;
  V_IMPU_PORC_BASE_IMPO      NUMBER;
  V_IMPU_INDI_BAIM_IMPU_INCL VARCHAR2(1);

  V_DETA_MOVI_CODI               NUMBER(20);
  V_DETA_NUME_ITEM               NUMBER(5);
  V_DETA_IMPU_CODI               NUMBER(10);
  V_DETA_PROD_CODI               NUMBER(20);
  V_DETA_CANT                    NUMBER(20, 4);
  V_DETA_OBSE                    VARCHAR2(2000);
  V_DETA_PORC_DETO               NUMBER(20, 6);
  V_DETA_IMPO_MONE               NUMBER(20, 4);
  V_DETA_IMPO_MMNN               NUMBER(20, 4);
  V_DETA_IMPO_MMEE               NUMBER(20, 4);
  V_DETA_IVA_MMNN                NUMBER(20, 4);
  V_DETA_IVA_MMEE                NUMBER(20, 4);
  V_DETA_IVA_MONE                NUMBER(20, 4);
  V_DETA_PREC_UNIT               NUMBER(20, 4);
  V_DETA_MOVI_CODI_PADR          NUMBER(20);
  V_DETA_NUME_ITEM_PADR          NUMBER(5);
  V_DETA_IMPO_MONE_DETO_NC       NUMBER(20, 4);
  V_DETA_MOVI_CODI_DETO_NC       NUMBER(20);
  V_DETA_LIST_CODI               NUMBER(4);
  V_DETA_MOVI_CLAVE_ORIG         NUMBER(20);
  V_DETA_IMPO_MMNN_DETO_NC       NUMBER(20, 4);
  V_DETA_BASE                    NUMBER(2);
  V_DETA_MOVI_ORIG_CODI          NUMBER(20);
  V_DETA_MOVI_ORIG_ITEM          NUMBER(4);
  V_DETA_LOTE_CODI               NUMBER(10);
  V_DETA_IMPO_MMEE_DETO_NC       NUMBER(20, 4);
  V_DETA_ASIE_CODI               NUMBER(10);
  V_DETA_CANT_MEDI               NUMBER(20, 4);
  V_DETA_MEDI_CODI               NUMBER(10);
  V_DETA_REMI_CODI               NUMBER(20);
  V_DETA_REMI_NUME_ITEM          NUMBER(5);
  V_DETA_BIEN_CODI               NUMBER(20);
  V_DETA_PREC_UNIT_LIST          NUMBER(20, 4);
  V_DETA_IMPO_DETO_MONE          NUMBER(20, 4);
  V_DETA_PORC_DETO_PREC          NUMBER(20, 6);
  V_DETA_BENE_CODI               NUMBER(4);
  V_DETA_CECO_CODI               NUMBER(20);
  V_DETA_CLPR_CODI               NUMBER(20);
  V_DETA_IMPO_MONE_II            NUMBER(20, 4);
  V_DETA_IMPO_MMNN_II            NUMBER(20, 4);
  V_DETA_GRAV10_II_MONE          NUMBER(20, 4);
  V_DETA_GRAV5_II_MONE           NUMBER(20, 4);
  V_DETA_GRAV10_II_MMNN          NUMBER(20, 4);
  V_DETA_GRAV5_II_MMNN           NUMBER(20, 4);
  V_DETA_GRAV10_MONE             NUMBER(20, 4);
  V_DETA_GRAV5_MONE              NUMBER(20, 4);
  V_DETA_GRAV10_MMNN             NUMBER(20, 4);
  V_DETA_GRAV5_MMNN              NUMBER(20, 4);
  V_DETA_IVA10_MONE              NUMBER(20, 4);
  V_DETA_IVA5_MONE               NUMBER(20, 4);
  V_DETA_IVA10_MMNN              NUMBER(20, 4);
  V_DETA_IVA5_MMNN               NUMBER(20, 4);
  V_DETA_EXEN_MONE               NUMBER(20, 4);
  V_DETA_EXEN_MMNN               NUMBER(20, 4);
  V_DETA_INDI_COST               VARCHAR2(1);
  V_DETA_IMPO_INTE_MONE          NUMBER(20, 4);
  V_DETA_IMPO_INTE_MMNN          NUMBER(20, 4);
  V_DETA_EXDE_CODI               NUMBER;
  V_DETA_EXDE_TIPO               VARCHAR2(1);
  V_DETA_EMSE_CODI               NUMBER(20);
  V_DETA_PROD_PREC_MAXI_DETO_EXC NUMBER(20, 4);
  V_DETA_PROD_CODI_BARR          VARCHAR2(30);
  V_DETA_PROD_PREC_MAXI_DETO     NUMBER(20, 4);
  V_DETA_INDI_VENC               VARCHAR2(1);
  V_DETA_IMPO_COST_DIRE_MMEE     NUMBER(20, 4);
  V_DETA_IMPO_COST_DIRE_MMNN     NUMBER(20, 4);
  V_DETA_TRAN_CODI               NUMBER(10);

  BEGIN
   -- raise_application_error(-20010, 'I_DETA_IMPU_CODI: '||I_DETA_IMPU_CODI);
    BEGIN
      SELECT IMPU_PORC,
             IMPU_PORC_BASE_IMPO,
             NVL(IMPU_INDI_BAIM_IMPU_INCL, 'S')
        INTO V_IMPU_PORC, V_IMPU_PORC_BASE_IMPO, V_IMPU_INDI_BAIM_IMPU_INCL
        FROM COME_IMPU
       WHERE IMPU_CODI = I_DETA_IMPU_CODI;
    END;

    V_DETA_IMPO_MONE_II := I_S_TOTAL;
    V_DETA_IMPO_MMNN_II := ROUND(I_S_TOTAL * I_MOVI_TASA_MONE, 0);

/*
    raise_application_error(-20010, ''||
                      'V_DETA_IMPO_MONE_II: '||V_DETA_IMPO_MONE_II||' ; '||
                      'I_MOVI_MONE_CANT_DECI: '||I_MOVI_MONE_CANT_DECI||' ; '||
                      'V_IMPU_PORC: '||V_IMPU_PORC||' ; '||
                      'V_IMPU_PORC_BASE_IMPO: '||V_IMPU_PORC_BASE_IMPO||' ; '||
                      'V_IMPU_INDI_BAIM_IMPU_INCL: '||V_IMPU_INDI_BAIM_IMPU_INCL);
*/
    PA_DEVU_IMPO_CALC(V_DETA_IMPO_MONE_II, --P_IMPO_MONE      IN NUMBER,
                      I_MOVI_MONE_CANT_DECI, --P_CANT_DECI      IN NUMBER,
                      V_IMPU_PORC, --P_PORC_IMPU      IN NUMBER,
                      V_IMPU_PORC_BASE_IMPO, --P_PORC_BASE_IMPO IN NUMBER,
                      V_IMPU_INDI_BAIM_IMPU_INCL, --P_INDI_II        IN CHAR,
                      ---
                      V_DETA_IMPO_MONE_II,
                      V_DETA_GRAV10_II_MONE,
                      V_DETA_GRAV5_II_MONE,
                      V_DETA_GRAV10_MONE,
                      V_DETA_GRAV5_MONE,
                      V_DETA_IVA10_MONE,
                      V_DETA_IVA5_MONE,
                      V_DETA_EXEN_MONE);


    I_DETA_GRAV10_II_MONE := V_DETA_GRAV10_II_MONE;
    I_DETA_GRAV5_II_MONE  := V_DETA_GRAV5_II_MONE;
    I_DETA_EXEN_MONE      := V_DETA_EXEN_MONE;

  END PP_CALCULAR_IMPORTE_ITEM;

-----------------------------------------------
--validar modal
  procedure pp_validar_modal(I_PROD_CODI_ALFA in number,
                             I_DETA_CANT      in number,
                             I_DETA_PREC_UNIT in varchar2,
                             I_S_TOTAL        in varchar2
                             ) is

  begin
    if I_PROD_CODI_ALFA is null then
      raise_application_error(-20010, 'Debe de seleccionar un producto!.');
    end if;

    if I_DETA_CANT is null then
      raise_application_error(-20010, 'La cantidad no debe quedar vacia!.');
    elsif I_DETA_CANT <= 0 then
      raise_application_error(-20010, 'Cantidad que se ajustar?. Debe ser mayor a 0!.');
    end if;

    if I_DETA_PREC_UNIT is null then
      raise_application_error(-20010, 'El costo unitario no debe quedar vacio!.');
    elsif I_DETA_PREC_UNIT <= 0 then
      raise_application_error(-20010, 'El costo unitario debe ser mayor a cero!.');
    end if;

    if I_S_TOTAL is null then
      raise_application_error(-20010, 'El costo total no debe quedar vacio!.');
    elsif I_S_TOTAL <= 0 then
      raise_application_error(-20010, 'El costo total debe ser mayor a cero!.');
    end if;

  end;

-----------------------------------------------
  procedure pp_add_det (i_deta_prod_codi      in number,
                        i_deta_cant           in number,
                        i_deta_prec_unit      in varchar2,
                        i_s_total             in varchar2,
                        i_s_producto_desc     in varchar2,
                        i_prod_codi_alfa      in number,
                        i_prod_indi_lote      in varchar2,
                        i_deta_impu_codi      in number,
                        i_deta_lote_codi      in number,
                        i_deta_grav10_ii_mone in number,
                        i_deta_grav5_ii_mone  in number,
                        i_deta_exen_mone      in number
                        )is

    v_s_producto_cf   number;
    v_s_producto_desc varchar2(100);
    v_prec_unit       number;
    v_total           number;

    procedure pp_det_modal(i_prod_codi  in number,
                           o_s_producto_cf   out number,
                           o_s_producto_desc out varchar2) is

    begin

      select prod_codi_alfa, prod_desc
      into   o_s_producto_cf, o_s_producto_desc
      from come_prod, come_marc
      where  nvl(prod_indi_inac, 'N') = 'N'
      and marc_codi = prod_marc_codi
      and prod_codi= i_prod_codi;

    exception
      when no_data_found then
        raise_application_error(-20010,'Error, producto inexistente!.');
      when others then
        raise_application_error(-20010,'Error al buscar los detalles de la modal!. '||sqlerrm);

    end pp_det_modal;


  begin

    select to_number(trim(replace(i_deta_prec_unit,'.',''))) prec_unit, to_number(trim(replace(i_s_total,'.',''))) total
    into v_prec_unit,v_total
    from dual;

    pp_validar_modal(i_deta_prod_codi ,
                     i_deta_cant      ,
                     v_prec_unit,--i_deta_prec_unit ,
                     v_total--i_s_total
                     );
/*
    pp_det_modal (i_deta_prod_codi,
                  v_s_producto_cf,
                  v_s_producto_desc);
*/

    apex_collection.add_member(p_collection_name => parameter.collection_name,
                               p_c001            => i_deta_prod_codi,
                               p_c002            => i_prod_codi_alfa,--v_s_producto_cf,
                               p_c003            => i_s_producto_desc,--v_s_producto_desc,
                               p_c004            => i_deta_cant,
                               p_c005            => v_prec_unit,--i_deta_prec_unit,
                               p_c006            => v_total,--i_s_total,
                               p_c007            => i_prod_indi_lote,
                               p_c008            => i_deta_impu_codi,
                               p_c009            => i_deta_lote_codi,
                               p_c010            => i_deta_grav10_ii_mone,
                               p_c011            => i_deta_grav5_ii_mone,
                               p_c012            => i_deta_exen_mone
                               );
  end pp_add_det;

-----------------------------------------------
  procedure pp_validar_nulos (i_movi_nume           in number,
                              i_movi_oper_codi      in number,
                              i_movi_mone_codi      in number,
                              i_movi_fech_emis      in date,
                              i_movi_depo_codi_orig in number) is

  begin

    if i_movi_nume is null then
      raise_application_error(-20010, 'El Numero de Movimiento no puede estar vacio!.');
    end if;

    if i_movi_oper_codi is null then
      raise_application_error(-20010, 'La Operacion no puede estar vacia!.');
    end if;

    if i_movi_mone_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar una Moneda!.');
    end if;

    if i_movi_fech_emis is null then
      raise_application_error(-20010, 'Debe de seleccionar una Fecha valida!.');
    end if;

    if i_movi_depo_codi_orig is null then
      raise_application_error(-20010, 'Debe de seleccionar un Deposito valido!.');
    end if;

  end;
-----------------------------------------------
  procedure pp_validar_cabecera(i_movi_nume           in number,
                                i_movi_oper_codi      in number,
                                i_movi_mone_codi      in number,
                                i_movi_fech_emis      in date,
                                i_movi_depo_codi_orig in number) is

    v_movi_tasa_mmee number;
  begin

    pp_validar_nulos (i_movi_nume           ,
                      i_movi_oper_codi      ,
                      i_movi_mone_codi      ,
                      i_movi_fech_emis      ,
                      i_movi_depo_codi_orig );
    --pp_valida_nume();
    --pp_mostrar_operacion();
    --pp_valida_fech(bcab.movi_fech_emis);
    --pp_busca_tasa_mmee (parameter.p_codi_mone_mmee, v_movi_tasa_mmee);

  end pp_validar_cabecera;

-----------------------------------------------
  procedure pp_muestra_desc_mone(p_codi_mone      in number,
                               --p_desc_mone_abre out varchar2,
                               p_deci_mmee      out number) is
  begin
    select mone_cant_deci--,mone_desc_abre
      into p_deci_mmee--,p_desc_mone_abre
      from come_mone
     where mone_codi = p_codi_mone;

  exception
    when no_data_found then
      raise_application_error(-20010,'Descripci?n de la moneda inexistente!');
    when others then
      raise_application_error(-20010,'Error al buscar la cantidad de decimales!');
  end;

-----------------------------------------------
  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi         in number,
                                        p_deta_nume_item         in number,
                                        p_deta_impu_codi         in number,
                                        p_deta_prod_codi         in number,
                                        p_deta_cant              in number,
                                        p_deta_obse              in varchar2,
                                        p_deta_porc_deto         in number,
                                        p_deta_impo_mone         in number,
                                        p_deta_impo_mmnn         in number,
                                        p_deta_impo_mmee         in number,
                                        p_deta_iva_mmnn          in number,
                                        p_deta_iva_mmee          in number,
                                        p_deta_iva_mone          in number,
                                        p_deta_prec_unit         in number,
                                        p_deta_movi_codi_padr    in number,
                                        p_deta_nume_item_padr    in number,
                                        p_deta_impo_mone_deto_nc in number,
                                        p_deta_movi_codi_deto_nc in number,
                                        p_deta_list_codi         in number,
                                        p_deta_lote_codi         in number) is
  begin
    insert into come_movi_prod_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_impu_codi,
       deta_prod_codi,
       deta_cant,
       deta_obse,
       deta_porc_deto,
       deta_impo_mone,
       deta_impo_mmnn,
       deta_impo_mmee,
       deta_iva_mmnn,
       deta_iva_mmee,
       deta_iva_mone,
       deta_prec_unit,
       deta_movi_codi_padr,
       deta_nume_item_padr,
       deta_impo_mone_deto_nc,
       deta_movi_codi_deto_nc,
       deta_list_codi,
       deta_lote_codi,
       deta_base)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_impu_codi,
       p_deta_prod_codi,
       p_deta_cant,
       p_deta_obse,
       p_deta_porc_deto,
       p_deta_impo_mone,
       p_deta_impo_mmnn,
       p_deta_impo_mmee,
       p_deta_iva_mmnn,
       p_deta_iva_mmee,
       p_deta_iva_mone,
       p_deta_prec_unit,
       p_deta_movi_codi_padr,
       p_deta_nume_item_padr,
       p_deta_impo_mone_deto_nc,
       p_deta_movi_codi_deto_nc,
       p_deta_list_codi,
       p_deta_lote_codi,
       parameter.p_codi_base);

  end pp_insert_come_movi_prod_deta;

-----------------------------------------------

procedure pp_actualiza_come_movi(i_movi_sucu_codi_orig in number,
                                    i_movi_depo_codi_orig in number,
                                    i_movi_oper_codi in number,
                                    i_movi_mone_codi in number,
                                    i_movi_nume in number,
                                    i_movi_fech_emis in date,
                                    i_movi_tasa_mone in number,
                                    i_movi_tasa_mmee in number,
                                    i_movi_obse in varchar2,
                                    i_movi_mone_cant_deci in number,
                                    i_movi_stoc_suma_rest       in varchar2,
                                    i_movi_stoc_afec_cost_prom  in varchar2,
                                    i_empresa                   in number) is

  V_MOVI_CODI                    NUMBER(20);
  V_MOVI_TIMO_CODI               NUMBER(10);
  V_MOVI_CLPR_CODI               NUMBER(20);
  V_MOVI_SUCU_CODI_ORIG          NUMBER(10);
  V_MOVI_DEPO_CODI_ORIG          NUMBER(10);
  V_MOVI_SUCU_CODI_DEST          NUMBER(10);
  V_MOVI_DEPO_CODI_DEST          NUMBER(10);
  V_MOVI_OPER_CODI               NUMBER(10);
  V_MOVI_CUEN_CODI               NUMBER(4);
  V_MOVI_MONE_CODI               NUMBER(4);
  V_MOVI_NUME                    NUMBER(20);
  V_MOVI_FECH_EMIS               DATE;
  V_MOVI_FECH_GRAB               DATE;
  V_MOVI_USER                    VARCHAR2(20);
  V_MOVI_CODI_PADR               NUMBER(20);
  V_MOVI_TASA_MONE               NUMBER(20, 4);
  V_MOVI_TASA_MMEE               NUMBER(20, 4);
  V_MOVI_GRAV_MMNN               NUMBER(20, 4);
  V_MOVI_EXEN_MMNN               NUMBER(20, 4);
  V_MOVI_IVA_MMNN                NUMBER(20, 4);
  V_MOVI_GRAV_MMEE               NUMBER(20, 4);
  V_MOVI_EXEN_MMEE               NUMBER(20, 4);
  V_MOVI_IVA_MMEE                NUMBER(20, 4);
  V_MOVI_GRAV_MONE               NUMBER(20, 4);
  V_MOVI_EXEN_MONE               NUMBER(20, 4);
  V_MOVI_IVA_MONE                NUMBER(20, 4);
  V_MOVI_OBSE                    VARCHAR2(2000);
  V_MOVI_SALD_MMNN               NUMBER(20, 4);
  V_MOVI_SALD_MMEE               NUMBER(20, 4);
  V_MOVI_SALD_MONE               NUMBER(20, 4);
  V_MOVI_STOC_SUMA_REST          VARCHAR2(1);
  V_MOVI_CLPR_DIRE               VARCHAR2(100);
  V_MOVI_CLPR_TELE               VARCHAR2(50);
  V_MOVI_CLPR_RUC                VARCHAR2(20);
  V_MOVI_CLPR_DESC               VARCHAR2(80);
  V_MOVI_EMIT_RECI               VARCHAR2(1);
  V_MOVI_AFEC_SALD               VARCHAR2(1);
  V_MOVI_DBCR                    VARCHAR2(1);
  V_MOVI_STOC_AFEC_COST_PROM     VARCHAR2(1);
  V_MOVI_EMPR_CODI               NUMBER(2);
  V_MOVI_CLAVE_ORIG              NUMBER(20);
  V_MOVI_CLAVE_ORIG_PADR         NUMBER(20);
  V_MOVI_INDI_IVA_INCL           VARCHAR2(1);
  V_MOVI_EMPL_CODI               NUMBER(10);
  V_MOVI_BASE                    NUMBER(2);
  V_MOVI_INDI_CONTA              VARCHAR2(1);
  V_MOVI_ORTR_CODI               NUMBER(20);
  V_MOVI_RRHH_MOVI_CODI          NUMBER(20);
  V_MOVI_ASIE_CODI               NUMBER(10);
  V_MOVI_EXCL_CONT               VARCHAR2(1);
  V_MOVI_CODI_RETE               NUMBER(20);
  V_MOVI_NUME_TIMB               VARCHAR2(20);
  V_MOVI_FECH_VENC_TIMB          DATE;
  V_MOVI_FECH_OPER               DATE;
  V_MOVI_CODI_PADR_VALI          NUMBER(20);
  V_MOVI_ORPE_CODI               NUMBER(20);
  V_MOVI_IMPO_RECA               NUMBER(20, 4);
  V_MOVI_IMPO_DETO               NUMBER(20, 4);
  V_MOVI_IMPO_CODI               NUMBER(20);
  V_MOVI_OBSE_DETA               VARCHAR2(500);
  V_MOVI_ORPA_CODI               NUMBER(20);
  V_MOVI_IMPO_DIFE_CAMB          NUMBER(20, 4);
  V_MOVI_MONE_CODI_LIQU          NUMBER(20, 4);
  V_MOVI_MONE_LIQU               NUMBER(20, 4);
  V_MOVI_TASA_MONE_LIQU          NUMBER(20, 4);
  V_MOVI_IMPO_MONE_LIQU          NUMBER(20, 4);
  V_MOVI_CONS_CODI               NUMBER(10);
  V_MOVI_INDI_INTE               VARCHAR2(1);
  V_MOVI_INDI_DEVE_GENE          VARCHAR2(1);
  V_MOVI_ORPE_CODI_LOCA          NUMBER(20);
  V_MOVI_FECH_INIC_TRAS          DATE;
  V_MOVI_FECH_TERM_TRAS          DATE;
  V_MOVI_TRAN_CODI               NUMBER(4);
  V_MOVI_VEHI_MARC               VARCHAR2(50);
  V_MOVI_VEHI_CHAP               VARCHAR2(20);
  V_MOVI_CONT_TRAN_NOMB          VARCHAR2(100);
  V_MOVI_CONT_TRAN_RUC           VARCHAR2(20);
  V_MOVI_COND_EMPL_CODI          NUMBER(10);
  V_MOVI_COND_NOMB               VARCHAR2(100);
  V_MOVI_COND_CEDU_NUME          VARCHAR2(20);
  V_MOVI_COND_DIRE               VARCHAR2(200);
  V_MOVI_SUCU_CODI_MOVI          NUMBER(10);
  V_MOVI_DEPO_CODI_MOVI          NUMBER(10);
  V_MOVI_ORTE_CODI               NUMBER(10);
  V_MOVI_CHEQ_INDI_DESC          VARCHAR2(1);
  V_MOVI_INDI_LIQU_TARJ          VARCHAR2(1);
  V_MOVI_IMPO_DETO_MONE          NUMBER(20, 4);
  V_MOVI_TIVA_CODI               NUMBER(10);
  V_MOVI_SERV_MOVI_CODI          NUMBER(20);
  V_MOVI_SERV_SALD_MONE          NUMBER(20, 4);
  V_MOVI_SERV_SALD_MMNN          NUMBER(20, 4);
  V_MOVI_SOCO_CODI               NUMBER(20);
  V_MOVI_INMU_CODI               NUMBER(10);
  V_MOVI_INDI_EXPE_PROC          VARCHAR2(1);
  V_MOVI_LIQU_CODI               NUMBER(20);
  V_MOVI_LIQU_CODI_EXPE          NUMBER(10);
  V_MOVI_VALE_INDI_IMPO          VARCHAR2(1);
  V_MOVI_FORM_ENTR_CODI          NUMBER(10);
  V_MOVI_INDI_TIPO_PRES          VARCHAR2(2);
  V_MOVI_SOMA_CODI               NUMBER(20);
  V_MOVI_SUB_CLPR_CODI           NUMBER(20);
  V_MOVI_SODE_CODI               NUMBER(20);
  V_MOVI_AQUI_PAGO_CODI          NUMBER(20);
  V_MOVI_INDI_ENTR_DEPO          VARCHAR2(1);
  V_MOVI_USER_ENTR_DEPO          VARCHAR2(20);
  V_MOVI_FECH_ENTR_DEPO          DATE;
  V_MOVI_INDI_COBR_DIFE          VARCHAR2(1);
  V_MOVI_INDI_IMPR               VARCHAR2(2);
  V_MOVI_LIVI_CODI               NUMBER(20);
  V_MOVI_ZARA_TIPO               VARCHAR2(1);
  V_MOVI_IMPO_MONE_II            NUMBER(20, 4);
  V_MOVI_IMPO_MMNN_II            NUMBER(20, 4);
  V_MOVI_CLAS_CODI               NUMBER(10);
  V_MOVI_FACT_CODI               NUMBER(20);
  V_MOVI_GRAV10_II_MONE          NUMBER(20, 4);
  V_MOVI_GRAV5_II_MONE           NUMBER(20, 4);
  V_MOVI_GRAV10_II_MMNN          NUMBER(20, 4);
  V_MOVI_GRAV5_II_MMNN           NUMBER(20, 4);
  V_MOVI_GRAV10_MONE             NUMBER(20, 4);
  V_MOVI_GRAV5_MONE              NUMBER(20, 4);
  V_MOVI_GRAV10_MMNN             NUMBER(20, 4);
  V_MOVI_GRAV5_MMNN              NUMBER(20, 4);
  V_MOVI_IVA10_MONE              NUMBER(20, 4);
  V_MOVI_IVA5_MONE               NUMBER(20, 4);
  V_MOVI_IVA10_MMNN              NUMBER(20, 4);
  V_MOVI_IVA5_MMNN               NUMBER(20, 4);
  V_MOVI_NOTA_DEVU_CODI          NUMBER(20);
  V_MOVI_INFO_CODI               NUMBER(20);
  V_MOVI_CLPR_SUCU_NUME_ITEM     NUMBER(20);
  V_MOVI_CLPR_SITU               NUMBER(10);
  V_MOVI_CLPR_EMPL_CODI_RECL     NUMBER(10);
  V_MOVI_VIAJ_CODI               NUMBER(20);
  V_MOVI_ZARA_CODI               NUMBER(20);
  V_MOVI_TURN_CODI               NUMBER(20);
  V_MOVI_CUEN_CODI_RECA          NUMBER(4);
  V_MOVI_CLPR_CODI_ORIG          NUMBER(20);
  V_MOVI_CLPR_SUCU_NUME_ITEM_ORI NUMBER(20);
  V_MOVI_INVE_CODI               NUMBER(10);
  V_MOVI_TACU_COMI               NUMBER(20, 4);
  V_MOVI_TACU_IVA                NUMBER(20, 4);
  V_MOVI_TACU_RETE_RENT          NUMBER(20, 4);
  V_MOVI_TACU_IVA_RETE_RENT      NUMBER(20, 4);
  V_MOVI_IMPO_INTE_MONE          NUMBER(20, 4);
  V_MOVI_IMPO_INTE_MMNN          NUMBER(20, 4);
  V_MOVI_INDI_OUTL               VARCHAR2(1);
  V_MOVI_APCI_CODI               NUMBER(20);
  V_MOVI_SOCO_CODI_ANTE          NUMBER(20);
  V_MOVI_SOCO_OPER               VARCHAR2(2);
  V_MOVI_SOCO_CLPR_CODI_ANTE     NUMBER(20);
  V_MOVI_TASA_MONE_PRES_BANC     NUMBER(20, 4);
  V_MOVI_INDI_DIAR               VARCHAR2(1);
  V_MOVI_NUME_SOLI               NUMBER(20);
  V_MOVI_NUME_COME               NUMBER(20);
  V_MOVI_INDI_CANT_DIAR          VARCHAR2(1);
  V_MOVI_INDI_MOST_FECH          VARCHAR2(1);
  V_MOVI_NUME_PLAN               NUMBER(20);
  V_MOVI_INDI_VERI_FECH          VARCHAR2(1);
  V_MOVI_INDI_ESTA               VARCHAR2(1);
  V_MOVI_SOPR_CODI               NUMBER(10);
  V_MOVI_LIST_CODI               NUMBER(10);
  V_MOVI_CODI_PROD_TRAS          NUMBER(10);

  v_total                        number:=0;
  BDET_SUM_DETA_GRAV10_II_MONE   number:=0;
  BDET_SUM_DETA_GRAV5_II_MONE    number:=0;
  V_SUM_DETA_GRAV5_II_MONE       number:=0;
  BDET_SUM_DETA_EXEN_MONE        number:=0;

  BEGIN

    --- asignar valores....
    for bdet in g_cursor_det loop

      v_total := v_total + to_number(bdet.S_TOTAL);
      BDET_SUM_DETA_GRAV5_II_MONE:= BDET_SUM_DETA_GRAV5_II_MONE + to_number(bdet.DETA_GRAV5_II_MONE);
      BDET_SUM_DETA_EXEN_MONE:= BDET_SUM_DETA_EXEN_MONE + to_number(bdet.DETA_EXEN_MONE);

    end loop;

    BDET_SUM_DETA_GRAV10_II_MONE := v_total;

    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := fa_empresa;

    V_MOVI_CODI      := bcab.movi_codi;
    V_MOVI_TIMO_CODI := NULL;

    V_MOVI_CLPR_CODI := null;--bcab.MOVI_CLPR_CODI;

    V_MOVI_SUCU_CODI_ORIG      := i_movi_sucu_codi_orig;
    V_MOVI_DEPO_CODI_ORIG      := i_movi_depo_codi_orig;
    V_MOVI_SUCU_CODI_DEST      := NULL;
    V_MOVI_DEPO_CODI_DEST      := NULL;
    V_MOVI_OPER_CODI           := i_movi_oper_codi;
    V_MOVI_CUEN_CODI           := NULL;
    V_MOVI_MONE_CODI           := i_movi_mone_codi;
    V_MOVI_NUME                := i_movi_nume;
    V_MOVI_FECH_EMIS           := i_movi_fech_emis;
    V_MOVI_FECH_GRAB           := bcab.movi_fech_grab;
    V_MOVI_USER                := bcab.movi_user;
    V_MOVI_CODI_PADR           := NULL;
    V_MOVI_TASA_MONE           := i_movi_tasa_mone;
    V_MOVI_TASA_MMEE           := i_movi_tasa_mmee;
    V_MOVI_OBSE                := i_movi_obse;
    V_MOVI_SALD_MMNN           := NULL;
    V_MOVI_SALD_MMEE           := NULL;
    V_MOVI_SALD_MONE           := NULL;
    V_MOVI_STOC_SUMA_REST      := i_movi_stoc_suma_rest;--bcab.movi_stoc_suma_rest;
    V_MOVI_CLPR_DIRE           := NULL;
    V_MOVI_CLPR_TELE           := NULL;
    V_MOVI_CLPR_RUC            := NULL;
    V_MOVI_CLPR_DESC           := NULL;
    V_MOVI_EMIT_RECI           := 'E';
    V_MOVI_AFEC_SALD           := NULL;
    V_MOVI_DBCR                := NULL;
    V_MOVI_STOC_AFEC_COST_PROM := i_movi_stoc_afec_cost_prom;--bcab.movi_stoc_afec_cost_prom;
    V_MOVI_EMPR_CODI           := i_empresa;
    V_MOVI_CLAVE_ORIG          := NULL;
    V_MOVI_CLAVE_ORIG_PADR     := NULL;
    V_MOVI_INDI_IVA_INCL       := NULL;
    V_MOVI_EMPL_CODI           := NULL;
    V_MOVI_BASE                := 1;
    V_MOVI_INDI_CONTA          := NULL;
    V_MOVI_ORTR_CODI           := NULL;
    V_MOVI_RRHH_MOVI_CODI      := NULL;
    V_MOVI_ASIE_CODI           := NULL;
    V_MOVI_EXCL_CONT           := NULL;
    V_MOVI_CODI_RETE           := NULL;
    V_MOVI_NUME_TIMB           := NULL;
    V_MOVI_FECH_VENC_TIMB      := NULL;
    V_MOVI_FECH_OPER           := i_movi_fech_emis;
    V_MOVI_CODI_PADR_VALI      := NULL;
    V_MOVI_ORPE_CODI           := NULL;
    V_MOVI_IMPO_RECA           := NULL;
    V_MOVI_IMPO_DETO           := NULL;
    V_MOVI_IMPO_CODI           := NULL;
    V_MOVI_OBSE_DETA           := NULL;
    V_MOVI_ORPA_CODI           := NULL;
    V_MOVI_IMPO_DIFE_CAMB      := NULL;
    V_MOVI_MONE_CODI_LIQU      := NULL;
    V_MOVI_MONE_LIQU           := NULL;
    V_MOVI_TASA_MONE_LIQU      := NULL;
    V_MOVI_IMPO_MONE_LIQU      := NULL;
    V_MOVI_CONS_CODI           := NULL;
    V_MOVI_INDI_INTE           := NULL;
    V_MOVI_INDI_DEVE_GENE      := NULL;
    V_MOVI_ORPE_CODI_LOCA      := NULL;
    V_MOVI_FECH_INIC_TRAS      := NULL;
    V_MOVI_FECH_TERM_TRAS      := NULL;
    V_MOVI_TRAN_CODI           := NULL;
    V_MOVI_VEHI_MARC           := NULL;
    V_MOVI_VEHI_CHAP           := NULL;
    V_MOVI_CONT_TRAN_NOMB      := NULL;
    V_MOVI_CONT_TRAN_RUC       := NULL;
    V_MOVI_COND_EMPL_CODI      := NULL;
    V_MOVI_COND_NOMB           := NULL;
    V_MOVI_COND_CEDU_NUME      := NULL;
    V_MOVI_COND_DIRE           := NULL;
    V_MOVI_SUCU_CODI_MOVI      := NULL;
    V_MOVI_DEPO_CODI_MOVI      := NULL;
    V_MOVI_ORTE_CODI           := NULL;
    V_MOVI_CHEQ_INDI_DESC      := NULL;
    V_MOVI_INDI_LIQU_TARJ      := NULL;
    V_MOVI_IMPO_DETO_MONE      := NULL;
    V_MOVI_TIVA_CODI           := NULL;
    V_MOVI_SERV_MOVI_CODI      := NULL;
    V_MOVI_SERV_SALD_MONE      := NULL;
    V_MOVI_SERV_SALD_MMNN      := NULL;
    V_MOVI_SOCO_CODI           := NULL;
    V_MOVI_INMU_CODI           := NULL;
    V_MOVI_INDI_EXPE_PROC      := NULL;
    V_MOVI_LIQU_CODI           := NULL;
    V_MOVI_LIQU_CODI_EXPE      := NULL;
    V_MOVI_VALE_INDI_IMPO      := NULL;
    V_MOVI_FORM_ENTR_CODI      := NULL;
    V_MOVI_INDI_TIPO_PRES      := NULL;
    V_MOVI_SOMA_CODI           := NULL;
    V_MOVI_SUB_CLPR_CODI       := NULL;
    V_MOVI_SODE_CODI           := NULL;
    V_MOVI_AQUI_PAGO_CODI      := NULL;
    V_MOVI_INDI_ENTR_DEPO      := NULL;
    V_MOVI_USER_ENTR_DEPO      := NULL;
    V_MOVI_FECH_ENTR_DEPO      := NULL;
    V_MOVI_INDI_COBR_DIFE      := NULL;
    V_MOVI_INDI_IMPR           := NULL;
    V_MOVI_LIVI_CODI           := NULL;
    V_MOVI_ZARA_TIPO           := NULL;
    V_MOVI_IMPO_MONE_II        := null;--:BDET.SUM_DETA_IMPO_MONE_II;
    V_MOVI_IMPO_MMNN_II        := null;--ROUND(:BDET.SUM_DETA_IMPO_MONE_II *i_movi_tasa_mone,0);

    V_MOVI_CLAS_CODI := NULL;
    V_MOVI_FACT_CODI := NULL;

    V_MOVI_GRAV10_II_MONE := BDET_SUM_DETA_GRAV10_II_MONE;
    V_MOVI_GRAV5_II_MONE  := BDET_SUM_DETA_GRAV5_II_MONE;

    V_MOVI_GRAV10_II_MMNN := ROUND(V_MOVI_GRAV10_II_MONE *
                                   i_movi_tasa_mone,
                                   0);
    V_MOVI_GRAV5_II_MMNN  := ROUND(V_MOVI_GRAV5_II_MONE *
                                   i_movi_tasa_mone,
                                   0);

    V_MOVI_GRAV10_MONE := ROUND(V_MOVI_GRAV10_II_MONE / 1.1,
                                i_movi_mone_cant_deci);
    V_MOVI_GRAV5_MONE  := ROUND(V_MOVI_GRAV5_II_MONE / 1.05,
                                i_movi_mone_cant_deci);

    V_MOVI_GRAV10_MMNN := ROUND(V_MOVI_GRAV10_II_MMNN / 1.1, 0);
    V_MOVI_GRAV5_MMNN  := ROUND(V_MOVI_GRAV5_II_MMNN / 1.05, 0);

    V_MOVI_IVA10_MONE := ROUND(V_MOVI_GRAV10_II_MONE / 11,
                               i_movi_mone_cant_deci);
    V_MOVI_IVA5_MONE  := ROUND(V_MOVI_GRAV5_II_MONE / 21,
                               i_movi_mone_cant_deci);

    V_MOVI_IVA10_MMNN := ROUND(V_MOVI_GRAV10_II_MMNN / 11,
                               i_movi_mone_cant_deci);
    V_MOVI_IVA5_MMNN  := ROUND(V_MOVI_GRAV5_II_MMNN / 21,
                               i_movi_mone_cant_deci);

    V_MOVI_GRAV_MMNN := V_MOVI_GRAV10_MMNN + V_MOVI_GRAV5_MMNN;
    V_MOVI_EXEN_MMNN := ROUND(BDET_SUM_DETA_EXEN_MONE * i_movi_tasa_mone,
                              0);
    V_MOVI_IVA_MMNN  := V_MOVI_IVA10_MMNN + V_MOVI_IVA5_MMNN;

    V_MOVI_GRAV_MONE := V_MOVI_GRAV10_MONE + V_MOVI_GRAV5_MONE;
    V_MOVI_EXEN_MONE := BDET_SUM_DETA_EXEN_MONE;
    V_MOVI_IVA_MONE  := V_MOVI_IVA10_MONE + V_MOVI_IVA5_MONE;

    V_MOVI_GRAV_MMEE := ROUND(V_MOVI_GRAV_MMNN / I_MOVI_TASA_MMEE, 2);
    V_MOVI_EXEN_MMEE := ROUND(V_MOVI_EXEN_MMNN / I_MOVI_TASA_MMEE, 2);
    V_MOVI_IVA_MMEE  := ROUND(V_MOVI_IVA_MMNN / I_MOVI_TASA_MMEE, 2);

    V_MOVI_NOTA_DEVU_CODI          := NULL;
    V_MOVI_INFO_CODI               := NULL;
    V_MOVI_CLPR_SUCU_NUME_ITEM     := NULL;
    V_MOVI_CLPR_SITU               := NULL;
    V_MOVI_CLPR_EMPL_CODI_RECL     := NULL;
    V_MOVI_VIAJ_CODI               := NULL;
    V_MOVI_ZARA_CODI               := NULL;
    V_MOVI_TURN_CODI               := NULL;
    V_MOVI_CUEN_CODI_RECA          := NULL;
    V_MOVI_CLPR_CODI_ORIG          := NULL;
    V_MOVI_CLPR_SUCU_NUME_ITEM_ORI := NULL;
    V_MOVI_INVE_CODI               := NULL;
    V_MOVI_TACU_COMI               := NULL;
    V_MOVI_TACU_IVA                := NULL;
    V_MOVI_TACU_RETE_RENT          := NULL;
    V_MOVI_TACU_IVA_RETE_RENT      := NULL;
    V_MOVI_IMPO_INTE_MONE          := NULL;
    V_MOVI_IMPO_INTE_MMNN          := NULL;
    V_MOVI_INDI_OUTL               := NULL;
    V_MOVI_APCI_CODI               := NULL;
    V_MOVI_SOCO_CODI_ANTE          := NULL;
    V_MOVI_SOCO_OPER               := NULL;
    V_MOVI_SOCO_CLPR_CODI_ANTE     := NULL;
    V_MOVI_TASA_MONE_PRES_BANC     := NULL;
    V_MOVI_INDI_DIAR               := NULL;
    V_MOVI_NUME_SOLI               := NULL;
    V_MOVI_NUME_COME               := NULL;
    V_MOVI_INDI_CANT_DIAR          := NULL;
    V_MOVI_INDI_MOST_FECH          := NULL;
    V_MOVI_NUME_PLAN               := NULL;
    V_MOVI_INDI_VERI_FECH          := NULL;
    V_MOVI_INDI_ESTA               := NULL;
    V_MOVI_SOPR_CODI               := NULL;
    V_MOVI_LIST_CODI               := NULL;
    V_MOVI_CODI_PROD_TRAS          := NULL;

    INSERT INTO COME_MOVI
      (MOVI_CODI,
       MOVI_TIMO_CODI,
       MOVI_CLPR_CODI,
       MOVI_SUCU_CODI_ORIG,
       MOVI_DEPO_CODI_ORIG,
       MOVI_SUCU_CODI_DEST,
       MOVI_DEPO_CODI_DEST,
       MOVI_OPER_CODI,
       MOVI_CUEN_CODI,
       MOVI_MONE_CODI,
       MOVI_NUME,
       MOVI_FECH_EMIS,
       MOVI_FECH_GRAB,
       MOVI_USER,
       MOVI_CODI_PADR,
       MOVI_TASA_MONE,
       MOVI_TASA_MMEE,
       MOVI_GRAV_MMNN,
       MOVI_EXEN_MMNN,
       MOVI_IVA_MMNN,
       MOVI_GRAV_MMEE,
       MOVI_EXEN_MMEE,
       MOVI_IVA_MMEE,
       MOVI_GRAV_MONE,
       MOVI_EXEN_MONE,
       MOVI_IVA_MONE,
       MOVI_OBSE,
       MOVI_SALD_MMNN,
       MOVI_SALD_MMEE,
       MOVI_SALD_MONE,
       MOVI_STOC_SUMA_REST,
       MOVI_CLPR_DIRE,
       MOVI_CLPR_TELE,
       MOVI_CLPR_RUC,
       MOVI_CLPR_DESC,
       MOVI_EMIT_RECI,
       MOVI_AFEC_SALD,
       MOVI_DBCR,
       MOVI_STOC_AFEC_COST_PROM,
       MOVI_EMPR_CODI,
       MOVI_CLAVE_ORIG,
       MOVI_CLAVE_ORIG_PADR,
       MOVI_INDI_IVA_INCL,
       MOVI_EMPL_CODI,
       MOVI_BASE,
       MOVI_INDI_CONTA,
       MOVI_ORTR_CODI,
       MOVI_RRHH_MOVI_CODI,
       MOVI_ASIE_CODI,
       MOVI_EXCL_CONT,
       MOVI_CODI_RETE,
       MOVI_NUME_TIMB,
       MOVI_FECH_VENC_TIMB,
       MOVI_FECH_OPER,
       MOVI_CODI_PADR_VALI,
       MOVI_ORPE_CODI,
       MOVI_IMPO_RECA,
       MOVI_IMPO_DETO,
       MOVI_IMPO_CODI,
       MOVI_OBSE_DETA,
       MOVI_ORPA_CODI,
       MOVI_IMPO_DIFE_CAMB,
       MOVI_MONE_CODI_LIQU,
       MOVI_MONE_LIQU,
       MOVI_TASA_MONE_LIQU,
       MOVI_IMPO_MONE_LIQU,
       MOVI_CONS_CODI,
       MOVI_INDI_INTE,
       MOVI_INDI_DEVE_GENE,
       MOVI_ORPE_CODI_LOCA,
       MOVI_FECH_INIC_TRAS,
       MOVI_FECH_TERM_TRAS,
       MOVI_TRAN_CODI,
       MOVI_VEHI_MARC,
       MOVI_VEHI_CHAP,
       MOVI_CONT_TRAN_NOMB,
       MOVI_CONT_TRAN_RUC,
       MOVI_COND_EMPL_CODI,
       MOVI_COND_NOMB,
       MOVI_COND_CEDU_NUME,
       MOVI_COND_DIRE,
       MOVI_SUCU_CODI_MOVI,
       MOVI_DEPO_CODI_MOVI,
       MOVI_ORTE_CODI,
       MOVI_CHEQ_INDI_DESC,
       MOVI_INDI_LIQU_TARJ,
       MOVI_IMPO_DETO_MONE,
       MOVI_TIVA_CODI,
       MOVI_SERV_MOVI_CODI,
       MOVI_SERV_SALD_MONE,
       MOVI_SERV_SALD_MMNN,
       MOVI_SOCO_CODI,
       MOVI_INMU_CODI,
       MOVI_INDI_EXPE_PROC,
       MOVI_LIQU_CODI,
       MOVI_LIQU_CODI_EXPE,
       MOVI_VALE_INDI_IMPO,
       MOVI_FORM_ENTR_CODI,
       MOVI_INDI_TIPO_PRES,
       MOVI_SOMA_CODI,
       MOVI_SUB_CLPR_CODI,
       MOVI_SODE_CODI,
       MOVI_AQUI_PAGO_CODI,
       MOVI_INDI_ENTR_DEPO,
       MOVI_USER_ENTR_DEPO,
       MOVI_FECH_ENTR_DEPO,
       MOVI_INDI_COBR_DIFE,
       MOVI_INDI_IMPR,
       MOVI_LIVI_CODI,
       MOVI_ZARA_TIPO,
       MOVI_IMPO_MONE_II,
       MOVI_IMPO_MMNN_II,
       MOVI_CLAS_CODI,
       MOVI_FACT_CODI,
       MOVI_GRAV10_II_MONE,
       MOVI_GRAV5_II_MONE,
       MOVI_GRAV10_II_MMNN,
       MOVI_GRAV5_II_MMNN,
       MOVI_GRAV10_MONE,
       MOVI_GRAV5_MONE,
       MOVI_GRAV10_MMNN,
       MOVI_GRAV5_MMNN,
       MOVI_IVA10_MONE,
       MOVI_IVA5_MONE,
       MOVI_IVA10_MMNN,
       MOVI_IVA5_MMNN,
       MOVI_NOTA_DEVU_CODI,
       MOVI_INFO_CODI,
       MOVI_CLPR_SUCU_NUME_ITEM,
       MOVI_CLPR_SITU,
       MOVI_CLPR_EMPL_CODI_RECL,
       MOVI_VIAJ_CODI,
       MOVI_ZARA_CODI,
       MOVI_TURN_CODI,
       MOVI_CUEN_CODI_RECA,
       MOVI_CLPR_CODI_ORIG,
       MOVI_CLPR_SUCU_NUME_ITEM_ORIG,
       MOVI_INVE_CODI,
       MOVI_TACU_COMI,
       MOVI_TACU_IVA,
       MOVI_TACU_RETE_RENT,
       MOVI_TACU_IVA_RETE_RENT,
       MOVI_IMPO_INTE_MONE,
       MOVI_IMPO_INTE_MMNN,
       MOVI_INDI_OUTL,
       MOVI_APCI_CODI,
       MOVI_SOCO_CODI_ANTE,
       MOVI_SOCO_OPER,
       MOVI_SOCO_CLPR_CODI_ANTE,
       MOVI_TASA_MONE_PRES_BANC,
       MOVI_INDI_DIAR,
       MOVI_NUME_SOLI,
       MOVI_NUME_COME,
       MOVI_INDI_CANT_DIAR,
       MOVI_INDI_MOST_FECH,
       MOVI_NUME_PLAN,
       MOVI_INDI_VERI_FECH,
       MOVI_INDI_ESTA,
       MOVI_SOPR_CODI,
       MOVI_LIST_CODI,
       MOVI_CODI_PROD_TRAS)
    VALUES
      (V_MOVI_CODI,
       V_MOVI_TIMO_CODI,
       V_MOVI_CLPR_CODI,
       V_MOVI_SUCU_CODI_ORIG,
       V_MOVI_DEPO_CODI_ORIG,
       V_MOVI_SUCU_CODI_DEST,
       V_MOVI_DEPO_CODI_DEST,
       V_MOVI_OPER_CODI,
       V_MOVI_CUEN_CODI,
       V_MOVI_MONE_CODI,
       V_MOVI_NUME,
       V_MOVI_FECH_EMIS,
       V_MOVI_FECH_GRAB,
       V_MOVI_USER,
       V_MOVI_CODI_PADR,
       V_MOVI_TASA_MONE,
       V_MOVI_TASA_MMEE,
       V_MOVI_GRAV_MMNN,
       V_MOVI_EXEN_MMNN,
       V_MOVI_IVA_MMNN,
       V_MOVI_GRAV_MMEE,
       V_MOVI_EXEN_MMEE,
       V_MOVI_IVA_MMEE,
       V_MOVI_GRAV_MONE,
       V_MOVI_EXEN_MONE,
       V_MOVI_IVA_MONE,
       V_MOVI_OBSE,
       V_MOVI_SALD_MMNN,
       V_MOVI_SALD_MMEE,
       V_MOVI_SALD_MONE,
       V_MOVI_STOC_SUMA_REST,
       V_MOVI_CLPR_DIRE,
       V_MOVI_CLPR_TELE,
       V_MOVI_CLPR_RUC,
       V_MOVI_CLPR_DESC,
       V_MOVI_EMIT_RECI,
       V_MOVI_AFEC_SALD,
       V_MOVI_DBCR,
       V_MOVI_STOC_AFEC_COST_PROM,
       V_MOVI_EMPR_CODI,
       V_MOVI_CLAVE_ORIG,
       V_MOVI_CLAVE_ORIG_PADR,
       V_MOVI_INDI_IVA_INCL,
       V_MOVI_EMPL_CODI,
       V_MOVI_BASE,
       V_MOVI_INDI_CONTA,
       V_MOVI_ORTR_CODI,
       V_MOVI_RRHH_MOVI_CODI,
       V_MOVI_ASIE_CODI,
       V_MOVI_EXCL_CONT,
       V_MOVI_CODI_RETE,
       V_MOVI_NUME_TIMB,
       V_MOVI_FECH_VENC_TIMB,
       V_MOVI_FECH_OPER,
       V_MOVI_CODI_PADR_VALI,
       V_MOVI_ORPE_CODI,
       V_MOVI_IMPO_RECA,
       V_MOVI_IMPO_DETO,
       V_MOVI_IMPO_CODI,
       V_MOVI_OBSE_DETA,
       V_MOVI_ORPA_CODI,
       V_MOVI_IMPO_DIFE_CAMB,
       V_MOVI_MONE_CODI_LIQU,
       V_MOVI_MONE_LIQU,
       V_MOVI_TASA_MONE_LIQU,
       V_MOVI_IMPO_MONE_LIQU,
       V_MOVI_CONS_CODI,
       V_MOVI_INDI_INTE,
       V_MOVI_INDI_DEVE_GENE,
       V_MOVI_ORPE_CODI_LOCA,
       V_MOVI_FECH_INIC_TRAS,
       V_MOVI_FECH_TERM_TRAS,
       V_MOVI_TRAN_CODI,
       V_MOVI_VEHI_MARC,
       V_MOVI_VEHI_CHAP,
       V_MOVI_CONT_TRAN_NOMB,
       V_MOVI_CONT_TRAN_RUC,
       V_MOVI_COND_EMPL_CODI,
       V_MOVI_COND_NOMB,
       V_MOVI_COND_CEDU_NUME,
       V_MOVI_COND_DIRE,
       V_MOVI_SUCU_CODI_MOVI,
       V_MOVI_DEPO_CODI_MOVI,
       V_MOVI_ORTE_CODI,
       V_MOVI_CHEQ_INDI_DESC,
       V_MOVI_INDI_LIQU_TARJ,
       V_MOVI_IMPO_DETO_MONE,
       V_MOVI_TIVA_CODI,
       V_MOVI_SERV_MOVI_CODI,
       V_MOVI_SERV_SALD_MONE,
       V_MOVI_SERV_SALD_MMNN,
       V_MOVI_SOCO_CODI,
       V_MOVI_INMU_CODI,
       V_MOVI_INDI_EXPE_PROC,
       V_MOVI_LIQU_CODI,
       V_MOVI_LIQU_CODI_EXPE,
       V_MOVI_VALE_INDI_IMPO,
       V_MOVI_FORM_ENTR_CODI,
       V_MOVI_INDI_TIPO_PRES,
       V_MOVI_SOMA_CODI,
       V_MOVI_SUB_CLPR_CODI,
       V_MOVI_SODE_CODI,
       V_MOVI_AQUI_PAGO_CODI,
       V_MOVI_INDI_ENTR_DEPO,
       V_MOVI_USER_ENTR_DEPO,
       V_MOVI_FECH_ENTR_DEPO,
       V_MOVI_INDI_COBR_DIFE,
       V_MOVI_INDI_IMPR,
       V_MOVI_LIVI_CODI,
       V_MOVI_ZARA_TIPO,
       V_MOVI_IMPO_MONE_II,
       V_MOVI_IMPO_MMNN_II,
       V_MOVI_CLAS_CODI,
       V_MOVI_FACT_CODI,
       V_MOVI_GRAV10_II_MONE,
       V_MOVI_GRAV5_II_MONE,
       V_MOVI_GRAV10_II_MMNN,
       V_MOVI_GRAV5_II_MMNN,
       V_MOVI_GRAV10_MONE,
       V_MOVI_GRAV5_MONE,
       V_MOVI_GRAV10_MMNN,
       V_MOVI_GRAV5_MMNN,
       V_MOVI_IVA10_MONE,
       V_MOVI_IVA5_MONE,
       V_MOVI_IVA10_MMNN,
       V_MOVI_IVA5_MMNN,
       V_MOVI_NOTA_DEVU_CODI,
       V_MOVI_INFO_CODI,
       V_MOVI_CLPR_SUCU_NUME_ITEM,
       V_MOVI_CLPR_SITU,
       V_MOVI_CLPR_EMPL_CODI_RECL,
       V_MOVI_VIAJ_CODI,
       V_MOVI_ZARA_CODI,
       V_MOVI_TURN_CODI,
       V_MOVI_CUEN_CODI_RECA,
       V_MOVI_CLPR_CODI_ORIG,
       V_MOVI_CLPR_SUCU_NUME_ITEM_ORI,
       V_MOVI_INVE_CODI,
       V_MOVI_TACU_COMI,
       V_MOVI_TACU_IVA,
       V_MOVI_TACU_RETE_RENT,
       V_MOVI_TACU_IVA_RETE_RENT,
       V_MOVI_IMPO_INTE_MONE,
       V_MOVI_IMPO_INTE_MMNN,
       V_MOVI_INDI_OUTL,
       V_MOVI_APCI_CODI,
       V_MOVI_SOCO_CODI_ANTE,
       V_MOVI_SOCO_OPER,
       V_MOVI_SOCO_CLPR_CODI_ANTE,
       V_MOVI_TASA_MONE_PRES_BANC,
       V_MOVI_INDI_DIAR,
       V_MOVI_NUME_SOLI,
       V_MOVI_NUME_COME,
       V_MOVI_INDI_CANT_DIAR,
       V_MOVI_INDI_MOST_FECH,
       V_MOVI_NUME_PLAN,
       V_MOVI_INDI_VERI_FECH,
       V_MOVI_INDI_ESTA,
       V_MOVI_SOPR_CODI,
       V_MOVI_LIST_CODI,
       V_MOVI_CODI_PROD_TRAS);

  END;

-----------------------------------------------
  PROCEDURE PP_ACTUALIZA_COME_MOVI_PROD(i_movi_tasa_mone in number,
                                      i_movi_mone_cant_deci in number,
                                      i_movi_codi           in number) IS

  V_DETA_MOVI_CODI               NUMBER(20);
  V_DETA_NUME_ITEM               NUMBER(5);
  V_DETA_IMPU_CODI               NUMBER(10);
  V_DETA_PROD_CODI               NUMBER(20);
  V_DETA_CANT                    NUMBER(20, 4);
  V_DETA_OBSE                    VARCHAR2(2000);
  V_DETA_PORC_DETO               NUMBER(20, 6);
  V_DETA_IMPO_MONE               NUMBER(20, 4);
  V_DETA_IMPO_MMNN               NUMBER(20, 4);
  V_DETA_IMPO_MMEE               NUMBER(20, 4);
  V_DETA_IVA_MMNN                NUMBER(20, 4);
  V_DETA_IVA_MMEE                NUMBER(20, 4);
  V_DETA_IVA_MONE                NUMBER(20, 4);
  V_DETA_PREC_UNIT               NUMBER(20, 4);
  V_DETA_MOVI_CODI_PADR          NUMBER(20);
  V_DETA_NUME_ITEM_PADR          NUMBER(5);
  V_DETA_IMPO_MONE_DETO_NC       NUMBER(20, 4);
  V_DETA_MOVI_CODI_DETO_NC       NUMBER(20);
  V_DETA_LIST_CODI               NUMBER(4);
  V_DETA_MOVI_CLAVE_ORIG         NUMBER(20);
  V_DETA_IMPO_MMNN_DETO_NC       NUMBER(20, 4);
  V_DETA_BASE                    NUMBER(2);
  V_DETA_MOVI_ORIG_CODI          NUMBER(20);
  V_DETA_MOVI_ORIG_ITEM          NUMBER(4);
  V_DETA_LOTE_CODI               NUMBER(10);
  V_DETA_IMPO_MMEE_DETO_NC       NUMBER(20, 4);
  V_DETA_ASIE_CODI               NUMBER(10);
  V_DETA_CANT_MEDI               NUMBER(20, 4);
  V_DETA_MEDI_CODI               NUMBER(10);
  V_DETA_REMI_CODI               NUMBER(20);
  V_DETA_REMI_NUME_ITEM          NUMBER(5);
  V_DETA_BIEN_CODI               NUMBER(20);
  V_DETA_PREC_UNIT_LIST          NUMBER(20, 4);
  V_DETA_IMPO_DETO_MONE          NUMBER(20, 4);
  V_DETA_PORC_DETO_PREC          NUMBER(20, 6);
  V_DETA_BENE_CODI               NUMBER(4);
  V_DETA_CECO_CODI               NUMBER(20);
  V_DETA_CLPR_CODI               NUMBER(20);
  V_DETA_IMPO_MONE_II            NUMBER(20, 4);
  V_DETA_IMPO_MMNN_II            NUMBER(20, 4);
  V_DETA_GRAV10_II_MONE          NUMBER(20, 4);
  V_DETA_GRAV5_II_MONE           NUMBER(20, 4);
  V_DETA_GRAV10_II_MMNN          NUMBER(20, 4);
  V_DETA_GRAV5_II_MMNN           NUMBER(20, 4);
  V_DETA_GRAV10_MONE             NUMBER(20, 4);
  V_DETA_GRAV5_MONE              NUMBER(20, 4);
  V_DETA_GRAV10_MMNN             NUMBER(20, 4);
  V_DETA_GRAV5_MMNN              NUMBER(20, 4);
  V_DETA_IVA10_MONE              NUMBER(20, 4);
  V_DETA_IVA5_MONE               NUMBER(20, 4);
  V_DETA_IVA10_MMNN              NUMBER(20, 4);
  V_DETA_IVA5_MMNN               NUMBER(20, 4);
  V_DETA_EXEN_MONE               NUMBER(20, 4);
  V_DETA_EXEN_MMNN               NUMBER(20, 4);
  V_DETA_INDI_COST               VARCHAR2(1);
  V_DETA_IMPO_INTE_MONE          NUMBER(20, 4);
  V_DETA_IMPO_INTE_MMNN          NUMBER(20, 4);
  V_DETA_EXDE_CODI               NUMBER;
  V_DETA_EXDE_TIPO               VARCHAR2(1);
  V_DETA_EMSE_CODI               NUMBER(20);
  V_DETA_PROD_PREC_MAXI_DETO_EXC NUMBER(20, 4);
  V_DETA_PROD_CODI_BARR          VARCHAR2(30);
  V_DETA_PROD_PREC_MAXI_DETO     NUMBER(20, 4);
  V_DETA_INDI_VENC               VARCHAR2(1);
  V_DETA_IMPO_COST_DIRE_MMEE     NUMBER(20, 4);
  V_DETA_IMPO_COST_DIRE_MMNN     NUMBER(20, 4);
  V_DETA_TRAN_CODI               NUMBER(10);

  V_IMPU_PORC                NUMBER;
  V_IMPU_PORC_BASE_IMPO      NUMBER;
  V_IMPU_INDI_BAIM_IMPU_INCL VARCHAR2(1);

  BEGIN

    V_DETA_NUME_ITEM := 0;

    for bdet in g_cursor_det loop

      BEGIN
        SELECT IMPU_PORC,
               IMPU_PORC_BASE_IMPO,
               NVL(IMPU_INDI_BAIM_IMPU_INCL, 'S')
          INTO V_IMPU_PORC, V_IMPU_PORC_BASE_IMPO, V_IMPU_INDI_BAIM_IMPU_INCL
          FROM COME_IMPU
         WHERE IMPU_CODI = BDET.DETA_IMPU_CODI;
      END;

      V_DETA_IMPO_MONE_II := BDET.S_TOTAL;
      V_DETA_IMPO_MMNN_II := ROUND(BDET.S_TOTAL * i_movi_tasa_mone, 0);

      PA_DEVU_IMPO_CALC(V_DETA_IMPO_MONE_II, --P_IMPO_MONE      IN NUMBER,
                        I_MOVI_MONE_CANT_DECI, --P_CANT_DECI      IN NUMBER,
                        V_IMPU_PORC, --P_PORC_IMPU      IN NUMBER,
                        V_IMPU_PORC_BASE_IMPO, --P_PORC_BASE_IMPO IN NUMBER,
                        V_IMPU_INDI_BAIM_IMPU_INCL, --P_INDI_II        IN CHAR,
                        ---
                        V_DETA_IMPO_MONE_II,
                        V_DETA_GRAV10_II_MONE,
                        V_DETA_GRAV5_II_MONE,
                        V_DETA_GRAV10_MONE,
                        V_DETA_GRAV5_MONE,
                        V_DETA_IVA10_MONE,
                        V_DETA_IVA5_MONE,
                        V_DETA_EXEN_MONE);

      PA_DEVU_IMPO_CALC(V_DETA_IMPO_MMNN_II, --P_IMPO_MONE      IN NUMBER,
                        I_MOVI_MONE_CANT_DECI, --P_CANT_DECI      IN NUMBER,
                        V_IMPU_PORC, --P_PORC_IMPU      IN NUMBER,
                        V_IMPU_PORC_BASE_IMPO, --P_PORC_BASE_IMPO IN NUMBER,
                        V_IMPU_INDI_BAIM_IMPU_INCL, --P_INDI_II        IN CHAR,
                        V_DETA_IMPO_MMNN_II,
                        V_DETA_GRAV10_II_MMNN,
                        V_DETA_GRAV5_II_MMNN,
                        V_DETA_GRAV10_MMNN,
                        V_DETA_GRAV5_MMNN,
                        V_DETA_IVA10_MMNN,
                        V_DETA_IVA5_MMNN,
                        V_DETA_EXEN_MMNN);

      V_DETA_MOVI_CODI         := I_MOVI_CODI;
      V_DETA_NUME_ITEM         := V_DETA_NUME_ITEM + 1;
      V_DETA_IMPU_CODI         := BDET.DETA_IMPU_CODI; ---SIEMPRE EXENTO
      V_DETA_PROD_CODI         := BDET.DETA_PROD_CODI;
      V_DETA_CANT              := BDET.DETA_CANT;
      V_DETA_OBSE              := NULL;
      V_DETA_PORC_DETO         := NULL;
      V_DETA_IMPO_MONE         := V_DETA_EXEN_MONE + V_DETA_GRAV10_MONE +
                                  V_DETA_GRAV5_MONE;
      V_DETA_IMPO_MMNN         := V_DETA_EXEN_MMNN + V_DETA_GRAV10_MMNN +
                                  V_DETA_GRAV5_MMNN;
      V_DETA_IMPO_MMEE         := NULL;
      V_DETA_IVA_MMNN          := V_DETA_IVA10_MMNN + V_DETA_IVA5_MMNN;
      V_DETA_IVA_MMEE          := 0;
      V_DETA_IVA_MONE          := V_DETA_IVA10_MONE + V_DETA_IVA5_MONE;
      V_DETA_PREC_UNIT         := BDET.DETA_PREC_UNIT;
      V_DETA_MOVI_CODI_PADR    := NULL;
      V_DETA_NUME_ITEM_PADR    := NULL;
      V_DETA_IMPO_MONE_DETO_NC := NULL;
      V_DETA_MOVI_CODI_DETO_NC := NULL;
      V_DETA_LIST_CODI         := NULL;
      V_DETA_MOVI_CLAVE_ORIG   := NULL;
      V_DETA_IMPO_MMNN_DETO_NC := NULL;
      V_DETA_BASE              := 1;
      V_DETA_MOVI_ORIG_CODI    := NULL;
      V_DETA_MOVI_ORIG_ITEM    := NULL;
      V_DETA_LOTE_CODI         := BDET.DETA_LOTE_CODI;
      V_DETA_IMPO_MMEE_DETO_NC := NULL;
      V_DETA_ASIE_CODI         := NULL;
      V_DETA_CANT_MEDI         := BDET.DETA_CANT;
      --V_DETA_MEDI_CODI         := :BDET.PROD_MEDI_CODI;
      V_DETA_REMI_CODI         := NULL;
      V_DETA_REMI_NUME_ITEM    := NULL;
      V_DETA_BIEN_CODI         := NULL;
      V_DETA_PREC_UNIT_LIST    := NULL;
      V_DETA_IMPO_DETO_MONE    := NULL;
      V_DETA_PORC_DETO_PREC    := NULL;
      V_DETA_BENE_CODI         := NULL;
      V_DETA_CECO_CODI         := NULL;
      V_DETA_CLPR_CODI         := NULL;

      V_DETA_INDI_COST               := NULL;
      V_DETA_IMPO_INTE_MONE          := 0;
      V_DETA_IMPO_INTE_MMNN          := 0;
      V_DETA_EXDE_CODI               := NULL;
      V_DETA_EXDE_TIPO               := NULL;
      V_DETA_EMSE_CODI               := NULL;
      V_DETA_PROD_PREC_MAXI_DETO_EXC := NULL;
      V_DETA_PROD_CODI_BARR          := BDET.S_PRODUCTO_CF;--:BDET.prod_codi_alfa;
      V_DETA_PROD_PREC_MAXI_DETO     := NULL;
      V_DETA_INDI_VENC               := NULL;
      V_DETA_IMPO_COST_DIRE_MMEE     := NULL;
      V_DETA_IMPO_COST_DIRE_MMNN     := NULL;
      V_DETA_TRAN_CODI               := NULL;

      INSERT INTO COME_MOVI_PROD_DETA
        (DETA_MOVI_CODI,
         DETA_NUME_ITEM,
         DETA_IMPU_CODI,
         DETA_PROD_CODI,
         DETA_CANT,
         DETA_OBSE,
         DETA_PORC_DETO,
         DETA_IMPO_MONE,
         DETA_IMPO_MMNN,
         DETA_IMPO_MMEE,
         DETA_IVA_MMNN,
         DETA_IVA_MMEE,
         DETA_IVA_MONE,
         DETA_PREC_UNIT,
         DETA_MOVI_CODI_PADR,
         DETA_NUME_ITEM_PADR,
         DETA_IMPO_MONE_DETO_NC,
         DETA_MOVI_CODI_DETO_NC,
         DETA_LIST_CODI,
         DETA_MOVI_CLAVE_ORIG,
         DETA_IMPO_MMNN_DETO_NC,
         DETA_BASE,
         DETA_MOVI_ORIG_CODI,
         DETA_MOVI_ORIG_ITEM,
         DETA_LOTE_CODI,
         DETA_IMPO_MMEE_DETO_NC,
         DETA_ASIE_CODI,
         DETA_CANT_MEDI,
         --DETA_MEDI_CODI,
         DETA_REMI_CODI,
         DETA_REMI_NUME_ITEM,
         DETA_BIEN_CODI,
         DETA_PREC_UNIT_LIST,
         DETA_IMPO_DETO_MONE,
         DETA_PORC_DETO_PREC,
         DETA_BENE_CODI,
         DETA_CECO_CODI,
         DETA_CLPR_CODI,
         DETA_IMPO_MONE_II,
         DETA_IMPO_MMNN_II,
         DETA_GRAV10_II_MONE,
         DETA_GRAV5_II_MONE,
         DETA_GRAV10_II_MMNN,
         DETA_GRAV5_II_MMNN,
         DETA_GRAV10_MONE,
         DETA_GRAV5_MONE,
         DETA_GRAV10_MMNN,
         DETA_GRAV5_MMNN,
         DETA_IVA10_MONE,
         DETA_IVA5_MONE,
         DETA_IVA10_MMNN,
         DETA_IVA5_MMNN,
         DETA_EXEN_MONE,
         DETA_EXEN_MMNN,
         DETA_INDI_COST,
         DETA_IMPO_INTE_MONE,
         DETA_IMPO_INTE_MMNN,
         DETA_EXDE_CODI,
         DETA_EXDE_TIPO,
         DETA_EMSE_CODI,
         DETA_PROD_PREC_MAXI_DETO_EXCE,
         DETA_PROD_CODI_BARR,
         DETA_PROD_PREC_MAXI_DETO,
         DETA_INDI_VENC,
         DETA_IMPO_COST_DIRE_MMEE,
         DETA_IMPO_COST_DIRE_MMNN,
         DETA_TRAN_CODI)
      VALUES
        (V_DETA_MOVI_CODI,
         V_DETA_NUME_ITEM,
         V_DETA_IMPU_CODI,
         V_DETA_PROD_CODI,
         V_DETA_CANT,
         V_DETA_OBSE,
         V_DETA_PORC_DETO,
         V_DETA_IMPO_MONE,
         V_DETA_IMPO_MMNN,
         V_DETA_IMPO_MMEE,
         V_DETA_IVA_MMNN,
         V_DETA_IVA_MMEE,
         V_DETA_IVA_MONE,
         V_DETA_PREC_UNIT,
         V_DETA_MOVI_CODI_PADR,
         V_DETA_NUME_ITEM_PADR,
         V_DETA_IMPO_MONE_DETO_NC,
         V_DETA_MOVI_CODI_DETO_NC,
         V_DETA_LIST_CODI,
         V_DETA_MOVI_CLAVE_ORIG,
         V_DETA_IMPO_MMNN_DETO_NC,
         V_DETA_BASE,
         V_DETA_MOVI_ORIG_CODI,
         V_DETA_MOVI_ORIG_ITEM,
         V_DETA_LOTE_CODI,
         V_DETA_IMPO_MMEE_DETO_NC,
         V_DETA_ASIE_CODI,
         V_DETA_CANT_MEDI,
         --V_DETA_MEDI_CODI,
         V_DETA_REMI_CODI,
         V_DETA_REMI_NUME_ITEM,
         V_DETA_BIEN_CODI,
         V_DETA_PREC_UNIT_LIST,
         V_DETA_IMPO_DETO_MONE,
         V_DETA_PORC_DETO_PREC,
         V_DETA_BENE_CODI,
         V_DETA_CECO_CODI,
         V_DETA_CLPR_CODI,
         V_DETA_IMPO_MONE_II,
         V_DETA_IMPO_MMNN_II,
         V_DETA_GRAV10_II_MONE,
         V_DETA_GRAV5_II_MONE,
         V_DETA_GRAV10_II_MMNN,
         V_DETA_GRAV5_II_MMNN,
         V_DETA_GRAV10_MONE,
         V_DETA_GRAV5_MONE,
         V_DETA_GRAV10_MMNN,
         V_DETA_GRAV5_MMNN,
         V_DETA_IVA10_MONE,
         V_DETA_IVA5_MONE,
         V_DETA_IVA10_MMNN,
         V_DETA_IVA5_MMNN,
         V_DETA_EXEN_MONE,
         V_DETA_EXEN_MMNN,
         V_DETA_INDI_COST,
         V_DETA_IMPO_INTE_MONE,
         V_DETA_IMPO_INTE_MMNN,
         V_DETA_EXDE_CODI,
         V_DETA_EXDE_TIPO,
         V_DETA_EMSE_CODI,
         V_DETA_PROD_PREC_MAXI_DETO_EXC,
         V_DETA_PROD_CODI_BARR,
         V_DETA_PROD_PREC_MAXI_DETO,
         V_DETA_INDI_VENC,
         V_DETA_IMPO_COST_DIRE_MMEE,
         V_DETA_IMPO_COST_DIRE_MMNN,
         V_DETA_TRAN_CODI);

      --EXIT WHEN :SYSTEM.LAST_RECORD = 'TRUE';
      --NEXT_RECORD;

    END LOOP;

  END PP_ACTUALIZA_COME_MOVI_PROD;


-----------------------------------------------
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
                              p_movi_empl_codi           in number) is
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
       movi_base)
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
       parameter.p_codi_base);

  end pp_insert_come_movi;

-----------------------------------------------
  procedure pp_validar_repeticion_prod is
  v_cant_reg number; --cantidad de registros en el bloque
  i          number;
  j          number;
  salir exception;
  v_ant_art number;
  v_ant_lot number;
  begin

    for c in (select c002 codi_prod, count(*)
                from apex_collections
               where collection_name = parameter.collection_name
               group by c002
              having count(*) > 1) loop

      raise_application_error(-20010,
      'El producto con codigo ' || c.codi_prod
       || ' se repite. Asegurese de no introducir mas de una vez el mismo codigo!');

    end loop;

  exception
    when salir then
      null;
  end pp_validar_repeticion_prod;

-----------------------------------------------
  procedure pp_reenumerar_nro_item is
  v_indi_borr varchar2(1) := 'N';
  v_nume_item number := 0;
  begin

    for bdet in g_cursor_det loop
      v_nume_item := v_nume_item + 1;
      --bdet.nro   := v_nume_item;
    end loop;

    if v_nume_item < 1 then
      raise_application_error(-20010,'Debe ingresar al menos un item');
    end if;


  end pp_reenumerar_nro_item;

-----------------------------------------------
  procedure pp_verifica_nume (movi_nume in out number) is

  v_nume number;

  begin
    v_nume := movi_nume;
    loop
      begin
        select movi_nume
          into v_nume
          from come_movi
         where movi_nume = v_nume
           and movi_oper_codi in (parameter.p_codi_oper_inve_inic);
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    movi_nume := v_nume;

  end pp_verifica_nume;

-----------------------------------------------
  procedure pp_actu_secu(i_movi_nume in number) is
  begin
    update come_secu
       set secu_nume_ajus = i_movi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = parameter.p_peco);

  end pp_actu_secu;

-----------------------------------------------
  procedure pp_imprimir_reportes is
  v_report       VARCHAR2(50);
  v_parametros   CLOB;
  v_contenedores CLOB;
  v_011          varchar2(200);
  v_012          varchar2(1000);

  begin

    --if parameter.p_movi_codi is null then
    if bcab.movi_codi is null then
      raise_application_error(-20010,'Error, debe de generar un registro!');
    end if;


    V_CONTENEDORES := 'p_codi_peri_actu:p_movi_codi';
    V_PARAMETROS   := parameter.p_codi_peri_actu || ':' ||bcab.movi_codi;--parameter.p_movi_codi;
    v_report       :='I020208';

    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = fa_empresa;

    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

    commit;
  end pp_imprimir_reportes;

-----------------------------------------------
  procedure pp_actualizar_registro(i_movi_nume           in number,
                                   i_movi_oper_codi      in number,
                                   i_movi_mone_codi      in number,
                                   i_movi_fech_emis      in date,
                                   i_movi_depo_codi_orig in number,
                                   i_movi_sucu_codi_orig in number,
                                   i_movi_tasa_mone      in number,
                                   i_movi_tasa_mmee      in varchar2,
                                   i_movi_obse           in varchar2,
                                   i_movi_mone_cant_deci in number,
                                   i_movi_stoc_suma_rest       in varchar2,
                                   i_movi_stoc_afec_cost_prom  in varchar2,
                                   i_empresa                   in number) is

  v_movi_nume number;
  v_movi_tasa_mmee number;
  begin


    v_movi_nume:= i_movi_nume;

    select to_number(trim(replace(i_movi_tasa_mmee,'.','')))
    into v_movi_tasa_mmee
    from dual;

    pp_validar_cabecera(v_movi_nume           ,
                        i_movi_oper_codi      ,
                        i_movi_mone_codi      ,
                        i_movi_fech_emis      ,
                        i_movi_depo_codi_orig );
    --
    --raise_application_error(-20010,'bcab.movi_nume= '|| bcab.movi_nume);
    --null;

    pp_valida_fech(i_movi_fech_emis);

    pp_reenumerar_nro_item;

    pp_validar_repeticion_prod;

    pp_verifica_nume (v_movi_nume);


    pp_actualiza_come_movi(i_movi_sucu_codi_orig,
                                    i_movi_depo_codi_orig,
                                    i_movi_oper_codi,
                                    i_movi_mone_codi,
                                    i_movi_nume,
                                    i_movi_fech_emis,
                                    i_movi_tasa_mone,
                                    v_movi_tasa_mmee,
                                    i_movi_obse,
                                    i_movi_mone_cant_deci,
                                    i_movi_stoc_suma_rest,
                                    i_movi_stoc_afec_cost_prom,
                                    i_empresa);
/*
    pp_actualiza_come_movi_prod(i_movi_mone_cant_deci,
                                i_movi_tasa_mone,
                                i_movi_tasa_mmee);
*/
    PP_ACTUALIZA_COME_MOVI_PROD(i_movi_tasa_mone,
                                i_movi_mone_cant_deci,
                                bcab.movi_codi--i_movi_codi
                                );

    pp_actu_secu(i_movi_nume);

    pp_imprimir_reportes();
    --apex_application.g_print_success_message := 'Registro guardado correctamente';

/*
    commit;

    if not form_success then
      go_block('bcab');
      clear_form(no_validate);
      message('Registro no actualizado !', no_acknowledge);
    else
      pp_llama_reporte;
      clear_form(no_validate);
      message('Registro actualizado.', no_acknowledge);
      go_block('bcab');
      pp_iniciar;
    end if;

    if form_failure then
      raise form_trigger_failure;
    end if;
  */
  end pp_actualizar_registro;

end I020208;
