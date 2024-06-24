
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I030001" is

  -- Private type declarations
  type r_parameter is record (
       p_cant_deci_cant      number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_cant')),
       p_orden_sucu_codi     varchar2(3):= 'asc',
       p_orden_sucu_desc     varchar2(3):= 'asc',
       p_orden_depo_codi     varchar2(3):= 'asc',
       p_orden_depo_desc     varchar2(3):= 'asc',
       p_orden_ubic          varchar2(3):= 'asc',
       p_orden_cant_actu     varchar2(3):= 'asc',
       p_indi_inst_prod_deta varchar2(1):= 'N',
       p_ind_validar_det     varchar2(1):= 'S',
       collection_name1       varchar2(50):= 'BDATOS',
       collection_name2       varchar2(50):= 'BDET_PROD',
       collection_name3       varchar2(50):= 'BDEPO_PROD',
       collection_name4       varchar2(50):= 'BPEDI_SUCU',
       collection_name5       varchar2(50):= 'BPEDI',
       collection_name6       varchar2(50):= 'BREMI',
       collection_name7       varchar2(50):= 'BSOLI_MATE',
       collection_name8       varchar2(50):= 'COLL_LOTES',
       collection_name9       varchar2(50):= 'COLL_LOTES_DETALLES'


  );

  parameter r_parameter;


-----------------------------------------------
  procedure pp_mostrar_producto(i_s_producto_cf   in varchar2,
                                o_s_producto_desc out varchar2,
                                o_producto        out number) is
    v_ind_inactivo char(1);

  begin
    
    select prod_desc, prod_codi, nvl(prod_indi_inac, 'N')
      into o_s_producto_desc, o_producto, v_ind_inactivo
      from come_prod
     where prod_codi_alfa = i_s_producto_cf;

    if v_ind_inactivo = 'S' then
      raise_application_error(-20010,'Atencion!!!!.. El producto se encuentra inactivo');
    end if;

  Exception
    when no_data_found then
      o_s_producto_desc := null;
      o_producto        := null;
      raise_application_error(-20010,'Producto inexistente!');
    when too_many_rows then
      raise_application_error(-20010,'Codigo duplicado');
    when others then
      raise_application_error(-20010,'Error al buscar producto!. ' || sqlerrm);

  end pp_mostrar_producto;

-----------------------------------------------
  function fp_buscar_prod_cod_barr(s_producto_cf in number) return boolean is
  v_prod_indi_inac varchar2(1) := 'N';
  Begin
    select prod_indi_inac--, prod_codi_alfa
      into v_prod_indi_inac--, s_producto_cf
      from come_prod, come_prod_coba_deta
     where prod_codi = coba_prod_codi
       and upper(ltrim(rtrim(coba_codi_barr))) = upper(ltrim(rtrim(s_producto_cf)));

    return true;
  Exception
    When no_data_found then
      return false;
  end fp_buscar_prod_cod_barr;

-----------------------------------------------
  function fp_buscar_prod_cod_alfa(s_producto_cf in number) return boolean is
  v_prod_indi_inac varchar2(1) := 'N';
  Begin
    select prod_indi_inac --,prod_codi_alfa
      into v_prod_indi_inac --,s_producto_cf
      from come_prod
     where prod_codi_alfa = s_producto_cf;

    return true;
  Exception
    When no_data_found then
      return false;
  end fp_buscar_prod_cod_alfa;

-----------------------------------------------
  function fp_buscar_prod_cod_fabr(s_producto_cf in number) return boolean is
  v_indi_inac varchar2(1);
  begin
    select nvl(prod_indi_inac, 'N') --,prod_codi_alfa
      into v_indi_inac --,s_producto_cf
      from come_prod
     where prod_codi_fabr = s_producto_cf;

    return true;
  Exception
    when no_data_found then
      return false;
    when others then
      --pl_mm('Codigo de fabrica duplicado')  ;
      raise_application_error(-20010, 'Codigo de fabrica duplicado');
      return false;
  end fp_buscar_prod_cod_fabr;

-----------------------------------------------
  procedure pp_validar_producto(i_s_producto_cf in number) is
    salir exception;
    v_prod varchar2(200);
    v_cant number := 0;
  begin

    --buscar articulo por codigo alfanumerico
    if fp_buscar_prod_cod_barr(i_s_producto_cf) then
      raise salir;
    end if;

    --buscar articulo por codigo alfanumerico
    if fp_buscar_prod_cod_alfa(i_s_producto_cf) then
      raise salir;
    end if;

    --buscar articulo por codigo de fabrica
    if fp_buscar_prod_cod_fabr(i_s_producto_cf) then
      raise salir;
    end if;

    parameter.p_ind_validar_det := 'N';
    --show_window('win_prod');
    --go_block('bdet_prod');
    --clear_block;
    --go_item('bsel_prod.s_producto_cf');

    --o_s_producto_cf := i_s_producto_cf;

    --do_key('next_item');


  exception
    when salir then
      null;
  end pp_validar_producto;

-----------------------------------------------
  PROCEDURE pp_devu_medi_maxi_mini(i_prod_codi    in number,
                                   i_unid_mini_maxi in varchar2,
                                   o_prod_medi_codi out number,
                                   o_prod_fact_conv out number
                                   ) IS
  BEGIN
    o_prod_medi_codi := nvl(fa_devu_medi_maxi_mini(i_prod_codi, i_unid_mini_maxi, 'U'),1);
    o_prod_fact_conv := nvl(fa_devu_medi_maxi_mini(i_prod_codi, i_unid_mini_maxi, 'C'),1);
  END;

-----------------------------------------------
  PROCEDURE pp_calc_cant_unid_medi(i_prde_cant_inic         in number,
                                 i_prod_fact_conv         in number, --viene del procedimiento anterior
                                 i_prde_cant_entr         in number,
                                 i_prde_cant_sali         in number,
                                 i_prde_cant_pedi_sucu    in number,
                                 i_prde_cant_actu         in number,
                                 i_prde_cant_pedi         in number,
                                 i_prde_cant_soli_mate    in number,
                                 i_prde_cant_remi         in number,
                                 i_prde_cant_venc         in number,
                                 o_cf_prde_cant_inic      out number,
                                 o_cf_prde_cant_entr      out number,
                                 o_cf_prde_cant_sali      out number,
                                 o_cf_prde_cant_pedi_sucu out number,
                                 o_cf_prde_cant_actu      out number,
                                 o_cf_prde_cant_pedi      out number,
                                 o_cf_prde_cant_soli_mate out number,
                                 o_cf_prde_cant_remi      out number,
                                 o_cf_prde_cant_venc      out number) IS
  BEGIN
    o_cf_prde_cant_inic      := nvl(i_prde_cant_inic, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_entr      := nvl(i_prde_cant_entr, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_sali      := nvl(i_prde_cant_sali, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_pedi_sucu := nvl(i_prde_cant_pedi_sucu, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_actu      := nvl(i_prde_cant_actu, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_pedi      := nvl(i_prde_cant_pedi, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_soli_mate := nvl(i_prde_cant_soli_mate, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_remi      := nvl(i_prde_cant_remi, 0) /
                                nvl(i_prod_fact_conv, 1);
    o_cf_prde_cant_venc      := nvl(i_prde_cant_venc, 0) /
                                nvl(i_prod_fact_conv, 1);

    --:bdatos.cf_orde_cant := nvl(:bdatos.orde_cant,0) / nvl(:bdatos.prod_fact_conv,1);
    --:bdatos.cf_impo_cant := nvl(:bdatos.impo_cant,0) / nvl(:bdatos.prod_fact_conv,1);
  END;


-----------------------------------------------
  procedure pp_ejecutar_consulta(i_producto in number,
                                 i_unid_mini_maxi in varchar2
                                 ) is

    TYPE tr_bdatos IS RECORD(
                  depo_codi  come_depo.depo_codi%type,
                  depo_desc  come_depo.depo_desc%type,
                  depo_codi_alte come_depo.depo_codi_alte%type,
                  depo_indi_visi come_depo.depo_indi_visi%type,
                  depo_indi_fact come_depo.depo_indi_fact%type,
                  sucu_codi      come_sucu.sucu_codi%type,
                  sucu_desc      come_sucu.sucu_desc%type,
                  prod_codi_alfa come_prod.prod_codi_alfa%type,
                  prod_codi      come_prod.prod_codi%type,
                  prod_desc      come_prod.prod_desc%type,
                  prde_ubic      come_prod_depo.prde_ubic%type,
                  prde_cant_actu come_prod_depo.prde_cant_actu%type,
                  prde_cant_inic come_prod_depo.prde_cant_inic%type,
                  prde_cant_entr come_prod_depo.prde_cant_entr%type,
                  prde_cant_sali come_prod_depo.prde_cant_sali%type,
                  prde_cant_pedi come_prod_depo.prde_cant_pedi%type,
                  prde_cant_remi come_prod_depo.prde_cant_remi%type,
                  prde_cant_venc come_prod_depo.prde_cant_venc%type,
                  prde_cant_pedi_sucu    come_prod_depo.prde_cant_pedi_sucu%type,
                  pres_cant              come_prod_depo.prde_cant_pedi%type,
                  remi_cant              come_prod_depo.prde_cant_remi%type,
                  prde_cant_soli_mate    come_prod_depo.prde_cant_soli_mate%type,
                  orde_cant              number,
                  impo_cant              number,
                  depo_desc_abre         come_depo.depo_desc_abre%type

      );

      TYPE tt_bdatos IS TABLE OF tr_bdatos INDEX BY BINARY_INTEGER;
      ta_bdatos tt_bdatos;

      v_count number;
      v_prod_medi_codi          number;
      v_prod_fact_conv          number;

      v_cf_prde_cant_inic       number;
      v_cf_prde_cant_entr       number;
      v_cf_prde_cant_sali       number;
      v_cf_prde_cant_pedi_sucu  number;
      v_cf_prde_cant_actu       number;
      v_cf_prde_cant_pedi       number;
      v_cf_prde_cant_soli_mate  number;
      v_cf_prde_cant_remi       number;
      v_cf_prde_cant_venc       number;
      v_cf_exis_neta            number;
      v_css_style               varchar2(100);

  begin

    if i_producto is null then
      raise_application_error(-20010,'Debe de seleccionar un producto!.');
    end if;
    --==>CARGAR COLECTION BDATOS<==
    select depo_codi,
       depo_desc,
       depo_codi_alte,
       depo_indi_visi,
       depo_indi_fact,
       sucu_codi,
       sucu_desc,
       prod_codi_alfa,
       prod_codi,
       prod_desc,
       prde_ubic,
       prde_cant_actu,
       prde_cant_inic,
       prde_cant_entr,
       prde_cant_sali,
       prde_cant_pedi,
       prde_cant_remi,
       prde_cant_venc,
       prde_cant_pedi_sucu,
       pres_cant,
       remi_cant,
       prde_cant_soli_mate,
       orde_cant,
       impo_cant,
       depo_desc_abre
   BULK COLLECT INTO ta_bdatos
    from v_come_depo_sucu_prod
   where prod_codi = i_producto
   order by to_number(depo_codi_alte);

   v_count := ta_bdatos.count;

   for x in 1 .. v_count loop

     pp_devu_medi_maxi_mini(ta_bdatos(x).prod_codi,
                            i_unid_mini_maxi,
                            v_prod_medi_codi,
                            v_prod_fact_conv
                            );

     pp_calc_cant_unid_medi(
        ta_bdatos(x).prde_cant_inic,
        v_prod_fact_conv,
        ta_bdatos(x).prde_cant_entr,
        ta_bdatos(x).prde_cant_sali,
        ta_bdatos(x).prde_cant_pedi_sucu,
        ta_bdatos(x).prde_cant_actu,
        ta_bdatos(x).prde_cant_pedi,
        ta_bdatos(x).prde_cant_soli_mate,
        ta_bdatos(x).prde_cant_remi,
        ta_bdatos(x).prde_cant_venc,
        v_cf_prde_cant_inic,
        v_cf_prde_cant_entr,
        v_cf_prde_cant_sali,
        v_cf_prde_cant_pedi_sucu,
        v_cf_prde_cant_actu,
        v_cf_prde_cant_pedi,
        v_cf_prde_cant_soli_mate,
        v_cf_prde_cant_remi,
        v_cf_prde_cant_venc
        );

        v_cf_exis_neta := NVL(v_cf_PRDE_CANT_ACTU,0)- NVL(v_cf_PRDE_CANT_PEDI,0) -
                          NVL(v_cf_PRDE_CANT_REMI,0)  - NVL(v_cf_PRDE_CANT_PEDI_SUCU,0) -
                          NVL(v_cf_PRDE_CANT_VENC,0);


        /*
        if v_cf_exis_neta <= 0 then
          v_css_style:='background-color: red;color: white;';
        else
          v_css_style:='';
        end if;
        */

        pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v('APP_SESSION'),
                                     i_taax_user => gen_user,
                                     i_taax_c001            => ta_bdatos(x).depo_codi,
                                      i_taax_c002            => ta_bdatos(x).depo_desc,
                                      i_taax_c003            => ta_bdatos(x).depo_codi_alte,
                                      i_taax_c004            => ta_bdatos(x).depo_indi_visi,
                                      i_taax_c005            => ta_bdatos(x).depo_indi_fact,
                                      i_taax_c006            => ta_bdatos(x).sucu_codi,
                                      i_taax_c007            => ta_bdatos(x).sucu_desc,
                                      i_taax_c008            => ta_bdatos(x).prod_codi_alfa,
                                      i_taax_c009            => ta_bdatos(x).prod_codi,
                                      i_taax_c010            => ta_bdatos(x).prod_desc,
                                      i_taax_c011            => ta_bdatos(x).prde_ubic,
                                      i_taax_c012            => ta_bdatos(x).prde_cant_actu,
                                      i_taax_c013            => ta_bdatos(x).prde_cant_inic,
                                      i_taax_c014            => ta_bdatos(x).prde_cant_entr,
                                      i_taax_c015            => ta_bdatos(x).prde_cant_sali,
                                      i_taax_c016            => ta_bdatos(x).prde_cant_pedi,
                                      i_taax_c017            => ta_bdatos(x).prde_cant_remi,
                                      i_taax_c018            => ta_bdatos(x).prde_cant_venc,
                                      i_taax_c019            => ta_bdatos(x).prde_cant_pedi_sucu,
                                      i_taax_c020            => ta_bdatos(x).pres_cant,
                                      i_taax_c021            => ta_bdatos(x).remi_cant,
                                      i_taax_c022            => ta_bdatos(x).prde_cant_soli_mate,
                                      i_taax_c023            => ta_bdatos(x).orde_cant,
                                      i_taax_c024            => ta_bdatos(x).impo_cant,
                                      i_taax_c025            => v_prod_medi_codi,
                                      i_taax_c026            => v_prod_fact_conv,
                                      i_taax_c027            => v_cf_prde_cant_inic,
                                      i_taax_c028            => v_cf_prde_cant_entr,
                                      i_taax_c029            => v_cf_prde_cant_sali,
                                      i_taax_c030            => v_cf_prde_cant_pedi_sucu,
                                      i_taax_c031            => v_cf_prde_cant_actu,
                                      i_taax_c032            => v_cf_prde_cant_pedi,
                                      i_taax_c033            => v_cf_prde_cant_soli_mate,
                                      i_taax_c034            => v_cf_prde_cant_remi,
                                      i_taax_c035            => v_cf_prde_cant_venc ,
                                      i_taax_c036            => v_cf_exis_neta,
                                      i_taax_c037            => v_css_style,
                                      i_taax_c038            => ta_bdatos(x).depo_desc_abre
                                     );


   end loop;


    --go_block('bdatos');
    --clear_block(no_validate);
    --execute_query;

    --pp_asig_colr;

  end pp_ejecutar_consulta;

-----------------------------------------------
  procedure pp_ejecutar_consulta_depo_prod is

  begin

    parameter.p_indi_inst_prod_deta := 'N';

    --go_block('bdepo_prod');
    --clear_block(no_validate);
    --execute_query;

    --go_block('bdet_prod');
    parameter.p_indi_inst_prod_deta := 'S';

  end pp_ejecutar_consulta_depo_prod;

-----------------------------------------------
/*
  PROCEDURE pp_filtrar(i_s_producto_cf in varchar2,
                       i_exist_cero    in varchar2,
                       i_buscar_por    in varchar2) IS

    ta_busc_prod_deta pack_fact.tt_busc_prod_deta;

    v_count number;

  BEGIN

    pack_fact.pa_busc_prod(i_s_producto_cf, --:bsel_prod.s_producto_cf,
                           i_exist_cero, --:bsel_prod.exist_cero, --S= tambi?n con  existencia cero  N= solo con existencia
                           i_buscar_por, --:bsel_prod.buscar_por, ---A= Codgio Alfa, D= Descripcion C= Codigo de fabrica, B= codigo Barras T= Todos
                           -1,
                           -1,
                           -1,
                           ta_busc_prod_deta);

    v_count := ta_busc_prod_deta.count;

    if v_count > 0 then


            for x in 1..v_count loop

                apex_collection.add_member(p_collection_name => parameter.collection_name2,
                                   p_c001            => ta_busc_prod_Deta(x).prod_Codi,
                                    p_c002            => ta_busc_prod_Deta(x).prod_codi_alfa,
                                    p_c003            => ta_busc_prod_Deta(x).prod_Desc,
                                    p_c004            => ta_busc_prod_Deta(x).coba_codi_barr,
                                    p_c005            => ta_busc_prod_Deta(x).prod_codi_fabr,
                                    p_c006            => ta_busc_prod_Deta(x).medi_desc_abre,
                                    p_c007            => ta_busc_prod_Deta(x).prod_prec,
                                    p_c008            => ta_busc_prod_Deta(x).prod_marc,
                                    p_c009            => ta_busc_prod_Deta(x).lote_Desc,
                                    p_c010            => ta_busc_prod_Deta(x).lote_codi,
                                    p_c011            => ta_busc_prod_Deta(x).lote_codi_barr

                               );

            end loop;


    else
      raise_application_error(-20010,
                              'No se encontraron coincidencias para el filtro ingresado de Producto.');
    end if;

  END;
*/

  PROCEDURE pp_filtrar(i_s_producto_cf in varchar2,
                     i_exist_cero    in varchar2,
                     i_buscar_por    in varchar2) IS

    ta_busc_prod_deta pack_fact.tt_busc_prod_deta;

    v_count number;

  BEGIN

    pack_fact.pa_busc_prod(i_s_producto_cf, --:bsel_prod.s_producto_cf,
                           i_exist_cero, --:bsel_prod.exist_cero, --S= tambi?n con  existencia cero  N= solo con existencia
                           i_buscar_por, --:bsel_prod.buscar_por, ---A= Codgio Alfa, D= Descripcion C= Codigo de fabrica, B= codigo Barras T= Todos
                           -1,
                           -1,
                           -1,
                           ta_busc_prod_deta);

    parameter.p_indi_inst_prod_deta := 'N';

    --- Al consultar una familia luego sin cancelar querer consultar nuevamente sale un error por parche 18
    --- por lo cual se hizo la siguiente trampita!!!
    --:parameter.p_where            := v_where;
    /*
    parameter.p_producto_cf      := :bsel_prod.s_producto_cf;
    parameter.p_indi_busc        := :bsel_prod.buscar_por;
    parameter.P_INDI_EXIST_CERO  := :bsel_prod.exist_cero;

    :bsel_prod.s_producto_cf := :parameter.p_producto_cf ;
    :bsel_prod.buscar_por := :parameter.p_indi_busc;
    :bsel_prod.exist_cero := :parameter.P_INDI_EXIST_CERO;
    */

    v_count := ta_busc_prod_deta.count;

    if v_count > 0 then

      for x in 1 .. v_count loop

        apex_collection.add_member(p_collection_name => parameter.collection_name2,
                                   p_c001            => ta_busc_prod_Deta(x).prod_Codi,
                                   p_c002            => ta_busc_prod_Deta(x).prod_codi_alfa,
                                   p_c003            => ta_busc_prod_Deta(x).prod_Desc,
                                   p_c004            => ta_busc_prod_Deta(x).coba_codi_barr,
                                   p_c005            => ta_busc_prod_Deta(x).prod_codi_fabr,
                                   p_c006            => ta_busc_prod_Deta(x).medi_desc_abre,
                                   p_c007            => ta_busc_prod_Deta(x).prod_prec,
                                   p_c008            => ta_busc_prod_Deta(x).prod_marc,
                                   p_c009            => ta_busc_prod_Deta(x).lote_Desc,
                                   p_c010            => ta_busc_prod_Deta(x).lote_codi,
                                   p_c011            => ta_busc_prod_Deta(x).lote_codi_barr
                                   );

      end loop;

      --delete_record;
      parameter.p_indi_inst_prod_deta := 'S';
      --first_record;

    else
      /*
      if get_item_property('bdet_prod.s_mens_auxi', visible) = 'TRUE' then
        set_item_property('bdet_prod.s_mens_auxi', visible, property_false);
      end if;
      go_item('bsel_prod.s_producto_cf');
      */
      raise_application_error(-20010,'No se encontraron coincidencias para el filtro ingresado de Producto.');
    end if;

  END pp_filtrar;

-----------------------------------------------
  function fp_exis_depo_fact return number is
    v_return number;
  begin
    /*if :bdepo_prod.prde_depo_codi = :bcab.inve_depo_codi then
      v_return := :bdepo_prod.prde_exis_neta;
    else*/
    v_return := 0;
    --end if;

    return v_return;
  end;

-----------------------------------------------
  procedure pp_ejecutar_consulta_depo_prod(i_lote_codi in number) is

    TYPE tr_bdepo_prod IS RECORD(
      prde_prod_codi      come_prod_depo_lote.prde_prod_codi%type,
      prde_depo_codi      come_prod_depo_lote.prde_depo_codi%type,
      prde_cant_remi      come_prod_depo_lote.prde_cant_remi%type,
      prde_cant_pedi      come_prod_depo_lote.prde_cant_pedi%type,
      prde_cant_pedi_sucu come_prod_depo_lote.prde_cant_pedi_sucu%type,
      prde_cant_actu      come_prod_depo_lote.prde_cant_actu%type--,
      --prde_exis_neta      come_prod_depo_lote.prde_exis_neta%type,
      --prde_depo_indi_visi come_prod_depo_lote.prde_depo_indi_visi%type
      );

    TYPE tt_bdepo_prod IS TABLE OF tr_bdepo_prod INDEX BY BINARY_INTEGER;
    ta_bdepo_prod tt_bdepo_prod;

    v_count     number;
    v_sucu_codi number;
    v_depo_desc varchar2(60);
    v_sucu_desc varchar2(60);

    v_s_exis_depo_fact    number;
    v_suma_exis_depo_fact number := 0;

    v_prde_exis_neta      number;

  begin

    parameter.p_indi_inst_prod_deta := 'N';

    /*
    go_block('bdepo_prod');
    clear_block(no_validate);
    execute_query;

    go_block('bdet_prod');
    */
    select prde_prod_codi,
           prde_depo_codi,
           prde_cant_remi,
           prde_cant_pedi,
           prde_cant_pedi_sucu,
           prde_cant_actu
          -- prde_exis_neta,
          -- prde_depo_indi_visi
      bulk collect
      into ta_bdepo_prod
      from come_prod_depo_lote
     WHERE prde_lote_codi = i_lote_codi
       and PRDE_CANT_ACTU > 0;

    v_count := ta_bdepo_prod.count;

    for x in 1 .. v_count loop

      general_skn.pl_muestra_come_depo(p_codi_depo => ta_bdepo_prod(x)
                                                      .prde_depo_codi,
                                       p_codi_sucu => v_sucu_codi,
                                       p_desc_depo => v_depo_desc,
                                       p_desc_sucu => v_sucu_desc);

      v_s_exis_depo_fact := 0; --fp_exis_depo_fact;

      v_suma_exis_depo_fact := v_suma_exis_depo_fact + v_s_exis_depo_fact;

      v_prde_exis_neta := nvl(ta_bdepo_prod(x).prde_cant_actu,0) - nvl(ta_bdepo_prod(x).prde_cant_pedi,0) -
                          nvl(ta_bdepo_prod(x).prde_cant_remi,0) -nvl(ta_bdepo_prod(x).prde_cant_pedi_sucu,0);


      apex_collection.add_member(p_collection_name => parameter.collection_name3,
                                 p_c001            => ta_bdepo_prod(x).prde_prod_codi,
                                 p_c002            => ta_bdepo_prod(x).prde_depo_codi,
                                 p_c003            => ta_bdepo_prod(x).prde_cant_remi,
                                 p_c004            => ta_bdepo_prod(x).prde_cant_pedi,
                                 p_c005            => ta_bdepo_prod(x).prde_cant_pedi_sucu,
                                 p_c006            => ta_bdepo_prod(x).prde_cant_actu,
                                 p_c007            => v_prde_exis_neta,--ta_bdepo_prod(x).prde_exis_neta,
                                 --p_c008            => ta_bdepo_prod(x).prde_depo_indi_visi,
                                 p_c009            => v_sucu_codi,
                                 p_c010            => v_depo_desc,
                                 p_c011            => v_sucu_desc,
                                 p_c012            => v_s_exis_depo_fact,
                                 p_c013            => v_suma_exis_depo_fact);

    end loop;

    parameter.p_indi_inst_prod_deta := 'S';

  end pp_ejecutar_consulta_depo_prod;

-----------------------------------------------
  procedure pp_cargar_bdepo_prod(i_lote_codi in number) is

  begin

    if parameter.p_indi_inst_prod_deta = 'S' then

      pp_ejecutar_consulta_depo_prod(i_lote_codi);
      /*
      if :parameter.p_asig_colo = 'N' then
        :parameter.p_asig_colo := 'S';
      end if;

      if :bdet_prod.prod_codi is not null and :parameter.p_asig_colo = 'S' then
        pp_asig_colr_busq;
      else
        :parameter.p_asig_colo := 'S';
      end if;
      */

      /*
      if :bdet_prod.prod_codi is not null and :bdepo_prod.suma_exis_depo_fact <= 0 then
        :bdet_prod.s_mens_auxi := 'EL PRODUCTO NO POSEE EXISTENCIA EN EL DEPOSITO A FACTURAR';
        set_item_property('bdet_prod.s_mens_auxi', visible, property_true);
      else
        set_item_property('bdet_prod.s_mens_auxi',visible,property_false);
      end if;
      */

    else
      pp_ejecutar_consulta_depo_prod(i_lote_codi);
    end if;

  end pp_cargar_bdepo_prod;

-----------------------------------------------
  procedure pp_cargar_pedi_sucu(p_prod_codi in number) is

    cursor c_pedi_sucu is
      select s.sotr_nume,
             s.sotr_fech_emis,
             od.depo_codi_alte depo_codi_orig,
             od.depo_desc depo_desc_orig,
             dd.depo_codi_alte depo_codi_dest,
             dd.depo_desc depo_desc_dest,
             os.sucu_codi_alte sucu_codi_orig,
             os.sucu_desc sucu_desc_orig,
             ds.sucu_codi_alte sucu_codi_dest,
             ds.sucu_desc sucu_desc_dest,
             b.deta_cant,
             b.deta_cant_sald,
             nvl(s.sotr_user_modi, s.sotr_user_regi) sotr_user
        from come_soli_tras_depo      s,
             come_soli_tras_depo_deta b,
             come_depo                od,
             come_depo                dd,
             come_sucu                os,
             come_sucu                ds
       where s.sotr_codi = b.deta_sotr_codi
         and s.sotr_depo_codi_orig = od.depo_codi(+)
         and s.sotr_depo_codi_dest = dd.depo_codi(+)
         and s.sotr_sucu_codi_orig = os.sucu_codi(+)
         and s.sotr_sucu_codi_dest = ds.sucu_codi(+)
         and nvl(s.sotr_esta, 'P') = 'P'
         and b.deta_prod_codi = p_prod_codi
       order by s.sotr_nume;

  begin

    for x in c_pedi_sucu loop

      apex_collection.add_member(p_collection_name => parameter.collection_name4,
                                 p_c001            => x.sotr_nume,
                                 p_c002            => x.sotr_fech_emis,
                                 p_c003            => x.depo_codi_orig,
                                 p_c004            => x.depo_desc_orig,
                                 p_c005            => x.depo_codi_dest,
                                 p_c006            => x.depo_desc_dest,
                                 p_c007            => x.sucu_codi_orig,
                                 p_c008            => x.sucu_desc_orig,
                                 p_c009            => x.sucu_codi_dest,
                                 p_c010            => x.sucu_desc_dest,
                                 p_c011            => x.deta_cant,
                                 p_c012            => x.deta_cant_sald,
                                 p_c013            => x.sotr_user);

    end loop;

  end pp_cargar_pedi_sucu;

-----------------------------------------------
  procedure pp_cargar_pedi(p_prod_codi in number) is
    cursor c_remi is
      select pres_nume, --nvl(a.pres_nume_char, a.pres_nume) pres_nume_char,
             a.pres_fech_emis,
             c.clpr_codi_alte,
             c.clpr_desc,
             empl_codi, -- nvl(d.empl_codi_alte, d.empl_codi) empl_codi_alte,
             d.empl_desc,
             b.dpre_prec_unit,
             b.dpre_porc_deto,
             b.dpre_impo_mone,
             b.dpre_cant,
             a.pres_user
        from come_pres_clie      a,
             come_pres_clie_deta b,
             come_clie_prov      c,
             come_empl           d
       where a.pres_codi = b.dpre_pres_codi
         and a.pres_clpr_codi = c.clpr_codi(+)
         and a.pres_empl_codi = d.empl_codi(+)
         and nvl(a.pres_tipo, 'A') = 'A'
         and nvl(a.pres_esta_pres, 'P') in ('P', 'C')
         and b.dpre_prod_codi = p_prod_codi
       order by a.pres_nume;

  begin

    for k in c_remi loop

      apex_collection.add_member(p_collection_name => parameter.collection_name5,
                                 p_c001            => k.pres_nume,
                                 p_c002            => k.pres_fech_emis,
                                 p_c003            => k.clpr_codi_alte,
                                 p_c004            => k.clpr_desc,
                                 p_c005            => k.empl_desc,
                                 p_c006            => k.dpre_cant,
                                 p_c007            => k.dpre_prec_unit,
                                 p_c008            => k.dpre_porc_deto,
                                 p_c009            => k.dpre_impo_mone,
                                 p_c010            => k.pres_user);

    end loop;

  end pp_cargar_pedi;

-----------------------------------------------
  procedure pp_cargar_remi(p_prod_codi in number) is
    cursor c_remi is
      select r.remi_nume,
             r.remi_fech,
             c.clpr_codi_alte,
             c.clpr_desc,
             nvl(d.deta_cant_sald, d.deta_cant) remi_cant,
             r.remi_user
        from come_remi r, come_remi_deta d, come_clie_prov c
       where r.remi_codi = d.deta_remi_codi
         and r.remi_clpr_codi = c.clpr_codi(+)
         and r.remi_moti_tras = 'V'
         and d.deta_prod_codi = p_prod_codi
         and nvl(d.deta_cant_sald, d.deta_cant) > 0
       order by r.remi_nume;
  begin

    for k in c_remi loop

      apex_collection.add_member(p_collection_name => parameter.collection_name6,
                                 p_c001            => k.remi_nume,
                                 p_c002            => k.remi_fech,
                                 p_c003            => k.clpr_codi_alte,
                                 p_c004            => k.clpr_desc,
                                 p_c005            => k.remi_cant,
                                 p_c006            => k.remi_user);

    end loop;

  end pp_cargar_remi;

-----------------------------------------------
  procedure pp_cargar_soli_mate(p_prod_codi in number) is
    cursor c_soli_mate is
      select soma_nume, --nvl(a.pres_nume_char, a.pres_nume) pres_nume_char,
             a.soma_fech_emis,
             a.soma_user_regi,
             c.clpr_codi_alte,
             c.clpr_desc,
             b.deta_cant,
             b.deta_cant_Sald,
             ortr_nume,
             depo_Codi_alte,
             depo_desc

        from come_soli_mate      a,
             come_soli_mate_deta b,
             come_clie_prov      c,
             come_orde_trab      ot,
             come_depo           de

       where a.soma_codi = deta_soma_codi
         and a.soma_ortr_codi = ot.ortr_codi
         and a.soma_depo_codi = depo_codi
         and ot.ortr_clpr_Codi = clpr_Codi
         and b.deta_prod_codi = p_prod_codi
         and nvl(b.deta_cant_sald, 0) > 0
       order by a.soma_nume;

  begin

    for k in c_soli_mate loop

      apex_collection.add_member(p_collection_name => parameter.collection_name7,
                                 p_c001            => k.soma_nume,
                                 p_c002            => k.soma_fech_emis,
                                 p_c003            => k.clpr_codi_alte,
                                 p_c004            => k.clpr_desc,
                                 p_c005            => k.deta_cant,
                                 p_c006            => k.deta_cant_Sald,
                                 p_c007            => k.ortr_nume,
                                 p_c008            => k.depo_codi_alte,
                                 p_c009            => k.depo_desc,
                                 p_c010            => k.soma_user_regi);


    end loop;

  end pp_cargar_soli_mate;

-----------------------------------------------
  procedure pp_imprimir_reportes (i_codi_prod in varchar2,
                                  i_user      in varchar2,
                                  i_session   in varchar2,
                                  i_desc_prod in varchar2,
                                  i_unid_medi in varchar2) is

    v_report       VARCHAR2(50);
    v_parametros   CLOB;
    v_contenedores CLOB;

    begin

      if i_codi_prod is null then
         raise_application_error(-20010,'Debe de seleccionar un producto!.');
      end if;
      if i_desc_prod is null then
         raise_application_error(-20010,'Debe de seleccionar un producto!.');
      end if;


      V_CONTENEDORES := 'p_codi_prod:p_user:p_session:p_desc_prod:p_unid_medi';

      V_PARAMETROS   :=   i_codi_prod || ':' ||
                          i_user      || ':' ||
                          i_session   || ':' ||
                          i_desc_prod || ':' ||
                          i_unid_medi;

      v_report       :='I030001';

      DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

      INSERT INTO COME_PARAMETROS_REPORT
        (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
      VALUES
        (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

      commit;
    end pp_imprimir_reportes;

-----------------------------------------------
  procedure pp_cargar_lotes(prod_codi in number,
                            depo_codi in number ) is

    cursor cur_lotes (p_prod_codi in number,p_depo_codi in number ) is
     select lote_codi, lote_desc, prde_cant_actu, t.depo_codi
      from v_come_depo_sucu_prod_lote t
      where t.prde_cant_actu <> 0
       and t.prod_codi = p_prod_codi
       and t.depo_codi = p_depo_codi
      order by 2 desc, 1 asc;

  begin

    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(parameter.collection_name8);

    for k in cur_lotes (prod_codi, depo_codi) loop

      apex_collection.add_member(p_collection_name => parameter.collection_name8,
                                 p_c001            => k.lote_codi,
                                 p_c002            => k.lote_desc,
                                 p_c003            => k.prde_cant_actu,
                                 p_c004            => k.depo_codi
                                 );
    end loop;

  end pp_cargar_lotes;

-----------------------------------------------
  procedure pp_cargar_lotes_detalles(lote_codi in number,
                                     depo_codi in number ) is

    cursor cur_lotes_det(p_lote_codi in number,p_depo_codi in number ) is
       select movi_nume numero,
         fech fecha,
        t.oper operacion,
        case
          when oper_codi = 3 then
           t.depo_dest
          else
           t.depo_orig
        end dep_origen,

        case
          when oper_codi = 3 then
           t.depo_orig
          else
           t.depo_dest
        end dep_destino,
        cant,
        t.movi_user,
        t.movi_obse,
        t.movi_codi,
        t.cliente

   from v_come_depo_sucu_prod_lote_det t
  where t.lote_codi = p_lote_codi
    and t.depo_codi = p_depo_codi
  order by movi_codi;

  begin
    /*
    raise_application_error(-20001,--lote_codi||';'||depo_codi );
    'lote_codi: '||lote_codi ||' ; '||
    'depo_codi: '||depo_codi );
    */

    APEX_COLLECTION.TRUNCATE_COLLECTION (parameter.collection_name9);

    for k in cur_lotes_det(lote_codi, depo_codi) loop

      apex_collection.add_member(p_collection_name => parameter.collection_name9,
                                  p_c001            => k.numero,
                                  p_c002            => k.fecha,
                                  p_c003            => k.operacion,
                                  p_c004            => k.dep_origen,
                                  p_c005            => k.dep_destino,
                                  p_c006            => k.cant,
                                  p_c007            => k.movi_user,
                                  p_c008            => k.movi_obse,
                                  p_c009            => k.movi_codi,
                                  p_c010            => k.cliente
                                 );
    end loop;

  end pp_cargar_lotes_detalles;
-----------------------------------------------


end I030001;
