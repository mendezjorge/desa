
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020041" is
  g_come_movi come_movi%rowtype;

  type r_parameter is record(
    p_codi_oper_sprod number := to_number(general_skn.fl_busca_parametro('p_codi_oper_sprod')),
    p_codi_oper_dprod number := to_number(general_skn.fl_busca_parametro('p_codi_oper_dprod')),
    p_form_cons_stoc  varchar2(20) := general_skn.fl_busca_parametro('p_form_cons_stoc'),
    p_form_anul_stoc  varchar2(20) := general_skn.fl_busca_parametro('p_form_anul_stoc'),
    p_repo_devu_mate  varchar2(20) := general_skn.fl_busca_parametro('p_repo_soli_mate'),
    p_codi_base       number := pack_repl.fa_devu_codi_base,
    p_cant_deci_mmnn  number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee  number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_codi_mone_mmee  number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    p_codi_mone_mmnn  number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_fech_inic       date,
    p_fech_fini       date,
    p_peco            number := 1,
    p_ind_is_prog     boolean := true);
  parameter r_parameter;

  cursor bdetalle is
    select a.seq_id deta_nume_item,
           a.c001   deta_prod_codi,
           a.c002   deta_cant,
           a.c003   deta_prec_unit,
           a.c004   deta_lote_codi,
           a.c005   deta_prec_unit_mmee,
           a.c007   prod_desc,
           a.c006   prod_cod_alfa,
           a.c014   deta_cant_soli,
           a.c015   deta_cant_devu,
           a.c016   movi_codi_padr_vali
      from apex_collections a
     where a.collection_name = 'BDETALLE';

  procedure pp_muestra_ot(p_ortr_nume in varchar2,
                          p_ortr_codi out number,
                          p_ortr_desc out char,
                          p_clpr_desc out char) is
    v_fech_liqu date;
  begin
  
    select ortr_desc, clpr_desc, ortr_codi, ortr_fech_liqu
      into p_ortr_desc, p_clpr_desc, p_ortr_codi, v_fech_liqu
      from come_orde_trab, come_clie_prov
     where ortr_clpr_codi = clpr_codi
       and ortr_nume = p_ortr_nume;
  
    if v_fech_liqu is not null then
      raise_application_error(-20001,
                              'La orden de trabajo est? liquidada!!!');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Orden de trabajo inexistente');
    when too_many_rows then
      raise_application_error(-20001,
                              'Existen mas de una orden de Trabajo con este numero');
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_muestra_ot;

  procedure pp_busca_soli_mate_nume(p_movi_nume           in number,
                                    p_movi_ortr_codi      in number,
                                    p_movi_nume_soli_mate in out number,
                                    p_depo_codi           out number,
                                    p_fech_emis           out date,
                                    p_movi_codi_padr_vali out number,
                                    p_ind_lista           out varchar2) is
  begin
    --  raise_application_error(-20001,p_movi_nume);
  
    select movi_codi, movi_depo_codi_orig, movi_fech_emis
      into p_movi_codi_padr_vali, p_depo_codi, p_fech_emis
      from come_movi
     where movi_nume = p_movi_nume_soli_mate
       and movi_oper_codi = parameter.p_codi_oper_sprod
       and movi_ortr_codi = p_movi_ortr_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Numero de solicitud inexistente');
    when too_many_rows then
      -- list_values;  
      p_ind_lista := 'S';
    
      if p_movi_codi_padr_vali is not null then
      
        pp_busca_soli_mate_codi(p_movi_nume_soli_mate,
                                p_movi_codi_padr_vali,
                                p_depo_codi,
                                p_fech_emis,
                                p_movi_ortr_codi);
      end if;
    
  end pp_busca_soli_mate_nume;

  procedure pp_buscar_nume(p_nume out number) is
  begin
  
    select (nvl(secu_nume_devu_mate, 0) + 1) nume
      into p_nume
      from come_secu s, come_pers_comp t
     where s.secu_codi = t.peco_secu_codi
       and t.peco_codi = parameter.p_peco;
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia no fue correctamente asignada a la terminal');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_buscar_nume;

  procedure pp_busca_soli_mate_codi(p_movi_nume      out number,
                                    p_movi_codi      in number,
                                    p_depo_codi      out number,
                                    p_fech_emis      out date,
                                    p_movi_ortr_codi in number) is
  begin
  
    select movi_nume, movi_depo_codi_orig, movi_fech_emis
      into p_movi_nume, p_depo_codi, p_fech_emis
      from come_movi
     where movi_codi = p_movi_codi
       and movi_oper_codi = parameter.p_codi_oper_sprod
       and movi_ortr_codi = p_movi_ortr_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Numero de solicitud inexistente');
  end pp_busca_soli_mate_codi;

  procedure pp_mostrar_producto(p_prod_codi_alfa          in number,
                                p_deta_nume_item_solma    in number,
                                p_movi_codi_padr_vali     in number,
                                p_movi_fech_emis          in date,
                                p_movi_ortr_codi          in number,
                                p_prod_desc               out varchar2,
                                p_deta_prod_codi          out number,
                                p_prod_indi_devo_sin_soli out varchar2,
                                p_prod_indi_lote          out varchar2,
                                p_deta_cant_devu          out number,
                                p_deta_lote_codi          out number,
                                p_deta_prec_unit_mmee     out number,
                                p_deta_cant_soli          out number,
                                p_deta_prec_unit          out number) is
    v_ind_inactivo char(1);
    v_peri_codi    number;
    v_lote_codi    number;
    --v_prod_indi_devo_sin_soli varchar2(1);
  begin
    select prod_desc,
           prod_codi,
           nvl(prod_indi_inac, 'N'),
           nvl(prod_indi_devo_sin_soli, 'N'),
           nvl(prod_indi_lote, 'N')
      into p_prod_desc,
           p_deta_prod_codi,
           v_ind_inactivo,
           p_prod_indi_devo_sin_soli,
           p_prod_indi_lote
      from come_prod
     where prod_codi_alfa = p_prod_codi_alfa;
  
    if v_ind_inactivo = 'S' then
      raise_application_error(-20001, 'El producto se encuentra inactivo');
    end if;
  
    --recuperar la cantidad de la solicitud a devolver...
    if nvl(p_prod_indi_devo_sin_soli, 'N') = 'N' then
      begin
        select round(deta_impo_mmnn / deta_cant, 4) deta_prec_unit,
               round((deta_impo_mmee / deta_cant),
                     parameter.p_cant_deci_mmee),
               sum(deta_cant),
               deta_lote_codi
          into p_deta_prec_unit,
               p_deta_prec_unit_mmee,
               p_deta_cant_soli,
               p_deta_lote_codi
          from come_movi_prod_deta, come_movi
         where movi_codi = deta_movi_codi
           and deta_movi_codi = p_movi_codi_padr_vali --codi de la solic de materiales
           and deta_prod_codi = p_deta_prod_codi
           and (p_deta_nume_item_solma is null or
               p_deta_nume_item_solma = deta_nume_item)
         group by round(deta_impo_mmnn / deta_cant, 4),
                  round((deta_impo_mmee / deta_cant),
                        parameter.p_cant_deci_mmee),
                  deta_lote_codi;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El producto que se desea devolver no se encuentra en la solicitud Seleccionada');
        when too_many_rows then
          --pl_me('el c?digo de producto se encuentra repetido en la solicitud de materiales. presione f9 para seleccionar el item que desea devolver.');
          -- pp_mostrar_producto_dupl;
          null;
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
      --cargar la cantidad ya devuelta (en caso q existan devoluciones previas del producto)  
      begin
        select nvl(sum(deta_cant), 0)
          into p_deta_cant_devu
          from come_movi_prod_deta, come_movi
         where deta_movi_codi = movi_codi
           and deta_prod_codi = p_deta_prod_codi
           and movi_oper_codi = parameter.p_codi_oper_dprod
           and movi_codi_padr_vali = p_movi_codi_padr_vali --probandooooo
           and movi_ortr_codi = p_movi_ortr_codi;
      
      exception
        when no_data_found then
          p_deta_cant_devu := 0;
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
      --el costo debe ser el mismo de la solicitud..... no debe tomar el costo promedio........
    else
    
      begin
        select peri_codi
          into v_peri_codi
          from come_peri
         where p_movi_fech_emis between peri_fech_inic and peri_fech_fini;
      
        if p_deta_lote_codi is null then
          v_lote_codi := fp_devu_lote_000000(p_deta_prod_codi);
        else
          v_lote_codi := p_deta_lote_codi;
        end if;
        p_deta_prec_unit := fa_devu_cost_prom_lote(v_lote_codi, v_peri_codi);
      exception
        when no_data_found then
          p_deta_prec_unit := 0;
      end;
    
    end if;
  
    -- raise_application_error(-20001,'pasasa');
  exception
    when no_data_found then
      p_prod_desc      := null;
      p_deta_prod_codi := null;
      raise_application_error(-20001, 'Producto inexistente!');
    when too_many_rows then
      raise_application_error(-20001, 'Codigo duplicado');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_mostrar_producto;

  procedure pp_cargar_lote(p_lote_codi               in number,
                           p_prod_indi_devo_sin_soli in varchar2,
                           p_prod_codi               in number,
                           p_movi_codi_padr_vali     in varchar2,
                           p_deta_nume_item_solma    in varchar2,
                           p_lote_indi_exis          out varchar2,
                           p_lote_desc               out varchar2,
                           p_lote_fech_elab          out varchar2,
                           p_lote_fech_venc          out varchar2,
                           p_lote_tele               out varchar2) is
    v_prod_codi number;
    v_count     number;
  begin
  
    select lote_prod_codi,
           lote_desc,
           lote_fech_elab,
           lote_fech_venc,
           lote_tele
      into v_prod_codi,
           p_lote_desc,
           p_lote_fech_elab,
           p_lote_fech_venc,
           p_lote_tele
      from come_lote
     where lote_codi = p_lote_codi;
  
    if v_prod_codi <> p_prod_codi then
    
      --p_lote_codi      := null;
      p_lote_desc      := null;
      p_lote_fech_elab := null;
      p_lote_fech_venc := null;
      p_lote_tele      := null;
      p_lote_indi_exis := 'N';
      raise_application_error(-20001,
                              'El lote indicado no pertenece al producto');
    else
    
      if nvl(p_prod_indi_devo_sin_soli, 'N') = 'N' then
      
        begin
          select count(*)
            into v_count
            from come_movi_prod_deta, come_movi
           where movi_codi = deta_movi_codi
             and deta_movi_codi = p_movi_codi_padr_vali --codi de la solic de materiales
             and deta_prod_codi = p_prod_codi
             and deta_lote_codi = p_lote_codi
             and (p_deta_nume_item_solma is null or
                 p_deta_nume_item_solma = deta_nume_item);
        
          --raise_application_error(-20001,p_lote_codi||'s sss');
        exception
          when others then
            v_count := 0;
        end;
      else
        v_count := 1;
      end if;
    
      if nvl(v_count, 0) <> 0 then
        --raise_application_error(-20001,p_lote_codi||'s sss');
        --  p_lote_fech_elab := to_char(p_lote_fech_elab, 'dd-mm-yyyy');
        --  p_lote_fech_venc := to_char(p_lote_fech_venc, 'dd-mm-yyyy');
        p_lote_indi_exis := 'S';
        -- pp_hab_desh_prod('d');
      else
        --p_lote_codi      := null;
        p_lote_desc      := null;
        p_lote_fech_elab := null;
        p_lote_fech_venc := null;
        p_lote_tele      := null;
        p_lote_indi_exis := 'N';
        raise_application_error(-20001,
                                'El lote del producto seleccionado no pertenece a la solicitud');
      end if;
    end if;
  
  exception
    when no_data_found then
      p_lote_indi_exis := 'N';
      --  pp_hab_desh_prod('h');
  end pp_cargar_lote;

  procedure pp_borrar_det(i_seq_id in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'BDETALLE',
                                  p_seq             => i_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'BDETALLE');
  
  end pp_borrar_det;

  procedure pp_validar_cant(p_deta_cant           in number,
                            p_movi_codi_padr_vali in number,
                            p_deta_cant_soli      in number,
                            p_deta_cant_devu      in number) is
  begin
  
    if nvl(p_deta_cant, 0) <= 0 then
      raise_application_error(-20001, 'Cantidad debe ser mayor a 0');
    end if;
  
    if p_movi_codi_padr_vali is not null then
      if (nvl(p_deta_cant_soli, 0) - nvl(p_deta_cant_devu, 0) -
         nvl(p_deta_cant, 0)) < 0 then
        raise_application_error(-20001,
                                'No se puede devolver una cantidad superior al saldo de la solicitud...' ||
                                to_char((nvl(p_deta_cant_soli, 0) -
                                        nvl(p_deta_cant_devu, 0))));
      end if;
    end if;
  end pp_validar_cant;

  procedure pp_valida_fech(p_fech in date) is
  begin
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
    
      raise_application_error(-20001,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                              ' y ' ||
                              to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end pp_valida_fech;

  procedure pp_verifica_nume is
    v_nume number;
  begin
    v_nume := g_come_movi.movi_nume;
    loop
      begin
        select movi_nume
          into v_nume
          from come_movi
         where movi_nume = v_nume
           and movi_oper_codi = parameter.p_codi_oper_dprod;
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    g_come_movi.movi_nume := v_nume;
  end pp_verifica_nume;

  procedure pp_actualiza_come_movi is
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_depo_codi_orig number;
    v_movi_sucu_codi_dest number;
    v_movi_depo_codi_dest number;
    v_movi_oper_codi      number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           varchar2(20);
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
    v_movi_obse           varchar2(2000);
    v_movi_sald_mmnn      number;
    v_movi_sald_mmee      number;
    v_movi_sald_mone      number;
    v_movi_stoc_suma_rest varchar2(1);
  
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number;
    v_movi_ortr_codi           number;
    v_movi_codi_padr_vali      number;
    v_movi_empl_codi           number;
    --v_movi_codi number;
  
  begin
  
    --- asignar valores....
    v_movi_codi           := fa_sec_come_movi;
    g_come_movi.movi_codi := v_movi_codi;
    -- v_movi_oper_codi  := parameter.p_codi_oper_dprod;
    pp_mostrar_operacion;
  
    v_movi_codi                := g_come_movi.movi_codi;
    v_movi_timo_codi           := null;
    v_movi_clpr_codi           := g_come_movi.movi_clpr_codi;
    v_movi_sucu_codi_orig      := g_come_movi.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := g_come_movi.movi_depo_codi_orig;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := parameter.p_codi_oper_dprod;
    v_movi_empl_codi           := g_come_movi.movi_empl_codi;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := g_come_movi.movi_nume;
    v_movi_fech_emis           := g_come_movi.movi_fech_emis;
    v_movi_fech_grab           := g_come_movi.movi_fech_grab;
    v_movi_user                := g_come_movi.movi_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := null;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := null;
    v_movi_exen_mmnn           := null;
    v_movi_iva_mmnn            := null;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := null;
    v_movi_exen_mone           := null;
    v_movi_iva_mone            := null;
    v_movi_obse                := g_come_movi.movi_obse;
    v_movi_sald_mmnn           := null;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := null;
    v_movi_stoc_suma_rest      := g_come_movi.movi_stoc_suma_rest;
    v_movi_stoc_afec_cost_prom := g_come_movi.movi_stoc_afec_cost_prom;
    v_movi_empr_codi           := null;
    v_movi_ortr_codi           := g_come_movi.movi_ortr_codi;
    v_movi_codi_padr_vali      := g_come_movi.movi_codi_padr_vali;
  
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
       movi_stoc_afec_cost_prom,
       movi_empr_codi,
       movi_ortr_codi,
       movi_codi_padr_vali,
       movi_base,
       movi_empl_codi)
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
       v_movi_stoc_afec_cost_prom,
       v_movi_empr_codi,
       v_movi_ortr_codi,
       v_movi_codi_padr_vali,
       parameter.p_codi_base,
       v_movi_empl_codi);
  
  end pp_actualiza_come_movi;

  procedure pp_mostrar_operacion is
  begin
  
    select oper_stoc_suma_rest, oper_stoc_afec_cost_prom
      into g_come_movi.movi_stoc_suma_rest,
           g_come_movi.movi_stoc_afec_cost_prom
      from come_stoc_oper
     where oper_codi = g_come_movi.movi_oper_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Operacion inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_mostrar_operacion;

  procedure pp_actualiza_come_movi_prod is
    v_deta_movi_codi         number;
    v_deta_nume_item         number;
    v_deta_impu_codi         number;
    v_deta_prod_codi         number;
    v_deta_cant              number;
    v_deta_obse              varchar2(2000);
    v_deta_porc_deto         number;
    v_deta_impo_mone         number;
    v_deta_impo_mmnn         number;
    v_deta_impo_mmee         number;
    v_deta_iva_mmnn          number;
    v_deta_iva_mmee          number;
    v_deta_iva_mone          number;
    v_deta_prec_unit         number;
    v_deta_movi_codi_padr    number;
    v_deta_nume_item_padr    number;
    v_deta_impo_mone_deto_nc number;
    v_deta_movi_codi_deto_nc number;
    v_deta_list_codi         number;
    v_deta_lote_codi         number;
  
  begin
    v_deta_movi_codi := g_come_movi.movi_codi;
  
    for bdet in bdetalle loop
      v_deta_nume_item         := bdet.deta_nume_item;
      v_deta_impu_codi         := 1; --exento
      v_deta_prod_codi         := bdet.deta_prod_codi;
      v_deta_cant              := bdet.deta_cant;
      v_deta_obse              := null;
      v_deta_porc_deto         := null;
      v_deta_impo_mone         := round((bdet.deta_prec_unit *
                                        bdet.deta_cant),
                                        parameter.p_cant_deci_mmnn);
      v_deta_impo_mmnn         := v_deta_impo_mone;
      v_deta_impo_mmee         := round((bdet.deta_prec_unit_mmee *
                                        bdet.deta_cant),
                                        parameter.p_cant_deci_mmee);
      v_deta_iva_mmnn          := 0;
      v_deta_iva_mmee          := 0;
      v_deta_iva_mone          := 0;
      v_deta_prec_unit         := bdet.deta_prec_unit;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
      --v_deta_lote_codi          := fp_devu_lote_000000(p_deta_prod_codi);
      v_deta_lote_codi := bdet.deta_lote_codi;
    
      begin
        -- call the procedure
        i020041.pp_validar_cant(p_deta_cant           => bdet.deta_cant,
                                p_movi_codi_padr_vali => bdet.movi_codi_padr_vali,
                                p_deta_cant_soli      => bdet.deta_cant_soli,
                                p_deta_cant_devu      => bdet.deta_cant_devu);
      end;
    
      ---inserta detalle
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
        (v_deta_movi_codi,
         v_deta_nume_item,
         v_deta_impu_codi,
         v_deta_prod_codi,
         v_deta_cant,
         v_deta_obse,
         v_deta_porc_deto,
         v_deta_impo_mone,
         v_deta_impo_mmnn,
         v_deta_impo_mmee,
         v_deta_iva_mmnn,
         v_deta_iva_mmee,
         v_deta_iva_mone,
         v_deta_prec_unit,
         v_deta_movi_codi_padr,
         v_deta_nume_item_padr,
         v_deta_impo_mone_deto_nc,
         v_deta_movi_codi_deto_nc,
         v_deta_list_codi,
         v_deta_lote_codi,
         parameter.p_codi_base);
    
    end loop;
  
  end pp_actualiza_come_movi_prod;

  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_devu_mate = g_come_movi.movi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = parameter.p_peco);
  
  end pp_actu_secu;

  procedure pp_add_det(p_deta_prod_codi      in varchar2,
                       p_deta_cant           in number,
                       p_deta_prec_unit      in varchar2,
                       p_deta_lote_codi      in varchar2,
                       p_deta_prec_unit_mmee in varchar2,
                       p_prod_codi_alfa      in varchar2,
                       p_prod_desc           in varchar2) as
  begin
  
    if nvl(p_deta_cant, 0) <= 0 then
      raise_application_error(-20001, 'La Cantidad debe ser mayor a 0 ');
    end if;
  
    apex_collection.add_member(p_collection_name => 'BDETALLE',
                               p_c001            => p_deta_prod_codi,
                               p_c002            => p_deta_cant,
                               p_c003            => p_deta_prec_unit,
                               p_c004            => p_deta_lote_codi,
                               p_c005            => p_deta_prec_unit_mmee,
                               p_c006            => p_prod_codi_alfa,
                               p_c007            => p_prod_desc,
                               p_c008            => v('p88_lote_desc'),
                               p_c009            => v('P88_S_LOTE_FECH_ELAB'),
                               p_c010            => v('P88_S_LOTE_FECH_VENC'),
                               p_c012            => v('P88_LOTE_TELE'),
                               p_c013            => v('P88_LOTE_INDI_EXIS'),
                               p_c014            => v('p88_deta_cant_soli'),
                               p_c015            => v('p88_deta_cant_devu'),
                               p_c016            => v('p88_movi_codi_padr_vali'));
  
  end pp_add_det;

  procedure pp_validar_datos(p_ortr_nume           in number,
                             p_movi_depo_codi_orig in number,
                             p_s_movi_fech_emis    in varchar2) is
  begin
    if p_ortr_nume is null then
      raise_application_error(-20001,
                              'Debe ingresar el Numero de orden de trabajo!');
    end if;
  
    if p_movi_depo_codi_orig is null then
      raise_application_error(-20001,
                              'Debe ingresar el codigo del Deposito!');
    end if;
  
    if p_s_movi_fech_emis is null then
      raise_application_error(-20001, 'Debe ingresar la fecha de emisi?n!');
    end if;
  
  end pp_validar_datos;

  function fp_devu_lote_000000(p_prod_codi in number) return number is
    v_lote_codi number;
  begin
  
    select lote_codi
      into v_lote_codi
      from come_lote
     where lote_prod_codi = p_prod_codi
       and lote_desc = '000000';
    return v_lote_codi;
  
  exception
    when no_data_found then
      return v_lote_codi;
  end fp_devu_lote_000000;

  procedure pp_set_variable is
  begin
    null;
  
    g_come_movi.movi_nume           := v('P88_MOVI_NUME');
    g_come_movi.movi_sucu_codi_orig := v('P88_MOVI_SUCU_CODI_ORIG');
    g_come_movi.movi_depo_codi_orig := v('P88_MOVI_DEPO_CODI_ORIG');
    g_come_movi.movi_oper_codi      := parameter.p_codi_oper_dprod;
    g_come_movi.movi_fech_emis      := v('P88_S_MOVI_FECH_EMIS');
    g_come_movi.movi_fech_grab      := sysdate;
    g_come_movi.movi_user           := fa_user;
    g_come_movi.movi_obse           := v('P88_MOVI_OBSE');
    g_come_movi.movi_ortr_codi      := v('p88_movi_ortr_codi');
    g_come_movi.movi_codi_padr_vali := v('p88_movi_codi_padr_vali');
  
  end pp_set_variable;

  procedure pp_actualizar_registro is
  begin
  
    if parameter.p_ind_is_prog then
      pp_set_variable;
    end if;
  
    pp_valida_fech(g_come_movi.movi_fech_emis);
  
    ---verificar validacion
    --pp_reenumerar_nro_item;
  
    pp_verifica_nume; --ok
  
    pp_actualiza_come_movi; --ok
  
    pp_actualiza_come_movi_prod; --ok
  
    pp_actu_secu; --ok
    pp_impr_reporte(g_come_movi.movi_codi);
  
  end pp_actualizar_registro;

  procedure pp_impr_reporte(p_movi_codi varchar2) is
    v_parametros   clob;
    v_contenedores clob;
  begin
  
    v_contenedores := 'p_movi_codi:p_titulo';
    v_parametros   := p_movi_codi || ':' || 'Devoluci?n de Materiales';
  
    delete from come_parametros_report where usuario = v('APP_USER');
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, fa_user, 'I020040MB', 'pdf', v_contenedores);
  
  end pp_impr_reporte;

  procedure pp_busca_dep_suc_tecn(i_empl_codi in number) as
  begin
    select t.user_depo_codi
      into g_come_movi.movi_depo_codi_orig
      from segu_user t
     where t.user_empl_codi = i_empl_codi;
  
    select t.depo_sucu_codi
      into g_come_movi.movi_sucu_codi_orig
      from come_depo t
     where t.depo_codi = g_come_movi.movi_depo_codi_orig;
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Error falta configurar deposito de tecnico');
  end pp_busca_dep_suc_tecn;

  procedure pp_generar_devolucion(i_vehi_codi      in number,
                                  i_empl_codi      in number,
                                  i_ortr_codi_inst in number,
                                  i_ortr_codi_des  in number,
                                  i_ortr_lote_codi in number,
                                  i_ortr_clpr_codi in number,
                                  i_ortr_nume      in number) as
  
    v_ind_deta         number := 0;
    v_movi_codi_salida number;
    e_salir            exception;
    v_fecha_inst       date;
    v_lote_codi        number;
    v_peri_codi        number;
    v_deta_prec_unit   number := 0;
  
    cursor cur_insu(ic_form_insu in number) is
      select t.cofid_codi,
             t.cofid_prod_codi,
             t.cofid_cant,
             t.cofid_reutiilizable,
             t.cofid_medi_codi
        from come_ortr_form_insu_det t
       where t.cofid_codi = ic_form_insu;
  
    cursor cur_det is
      select *
        from come_movi_prod_deta t
       where t.deta_movi_codi = g_come_movi.movi_codi_padr_vali;
  
    function fp_devolver_prod(i_prod_codi in number) return boolean is
      v_count number;
    begin
      select count(*)
        into v_count
        from come_ortr_form_insu_det t
       where t.cofid_reutiilizable = 'S'
         and t.cofid_prod_codi = i_prod_codi;
      if v_count > 0 then
        return true;
      else
        return false;
      end if;
    end fp_devolver_prod;
  
  begin
    parameter.p_ind_is_prog := false;
  
    select t.ortr_fech_inst
      into v_fecha_inst
      from COME_ORDE_TRAB t
     where t.ortr_codi = i_ortr_codi_des;
  
    -- pp_buscar_nume(p_nume => g_come_movi.movi_nume);
    g_come_movi.movi_nume := i_ortr_nume;
    pp_busca_dep_suc_tecn(i_empl_codi => i_empl_codi);
  
    g_come_movi.movi_oper_codi := parameter.p_codi_oper_dprod;
    g_come_movi.movi_fech_emis := trunc(v_fecha_inst);
    g_come_movi.movi_fech_grab := sysdate;
    g_come_movi.movi_user      := fa_user;
    g_come_movi.movi_ortr_codi := i_ortr_codi_des;
    g_come_movi.movi_clpr_codi := i_ortr_clpr_codi;
    g_come_movi.movi_empl_codi := i_empl_codi;
  
    select max(t.movi_codi) movi_codi
      into v_movi_codi_salida
      from come_movi t
     where t.movi_oper_codi in (12)
       and t.movi_ortr_codi = i_ortr_codi_inst;
  
    /* if i_ortr_codi_inst is null then
      raise_application_error(-20010,
                              'Codigo padre no encontrado, para devolucion de material');
    end if;*/
  
    if v_movi_codi_salida is null then
    
      /*  raise_application_error(-20010,
      'Error, al generar devolucion de material, no se ha encontrado la salida');*/
      --g_come_movi.movi_codi_padr_vali,
      g_come_movi.movi_obse := 'Devolucion generado, sin movimiento de salida 
      ot-ins: ' || i_ortr_codi_inst ||
                               ' *ot-des:' || i_ortr_codi_des;
    
      apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
    
      for c in cur_insu(1) loop
        if fp_devolver_prod(i_prod_codi => c.cofid_prod_codi) then
          v_ind_deta := 1;
        
          begin
            select peri_codi
              into v_peri_codi
              from come_peri
             where g_come_movi.movi_fech_emis between peri_fech_inic and
                   peri_fech_fini;
          
            v_deta_prec_unit := fa_devu_cost_prom_lote(i_ortr_lote_codi,
                                                       v_peri_codi);
          exception
            when no_data_found then
              v_deta_prec_unit := 0;
          end;
        
          i020041.pp_add_det(p_deta_prod_codi      => c.cofid_prod_codi,
                             p_deta_cant           => c.cofid_cant,
                             p_deta_prec_unit      => v_deta_prec_unit,
                             p_deta_lote_codi      => i_ortr_lote_codi,
                             p_deta_prec_unit_mmee => v_deta_prec_unit,
                             p_prod_codi_alfa      => '',
                             p_prod_desc           => '');
        end if;
      end loop;
    
      if v_ind_deta = 0 then
        raise_application_error(-20010,
                                'No se encontró detalles en la salida');
      end if;
    
    else
      select t.movi_codi, t.movi_obse
        into g_come_movi.movi_codi_padr_vali, g_come_movi.movi_obse
        from come_movi t
       where t.movi_codi = v_movi_codi_salida;
    
      g_come_movi.movi_obse := 'devolucion por desinstalacion ot-ins: ' ||
                               i_ortr_codi_inst || ' *ot-des:' ||
                               i_ortr_codi_des;
    
      apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
    
      for c in cur_det loop
        if fp_devolver_prod(i_prod_codi => c.deta_prod_codi) then
          v_ind_deta := 1;
          if c.deta_prod_codi = 30173201 then
            v_lote_codi := i_ortr_lote_codi;
          else
            v_lote_codi := c.deta_lote_codi;
          end if;
        
          begin
            select peri_codi
              into v_peri_codi
              from come_peri
             where g_come_movi.movi_fech_emis between peri_fech_inic and
                   peri_fech_fini;
          
            v_deta_prec_unit := fa_devu_cost_prom_lote(v_lote_codi,
                                                       v_peri_codi);
          exception
            when no_data_found then
              v_deta_prec_unit := 0;
          end;
        
          i020041.pp_add_det(p_deta_prod_codi      => c.deta_prod_codi,
                             p_deta_cant           => c.deta_cant,
                             p_deta_prec_unit      => v_deta_prec_unit,
                             p_deta_lote_codi      => v_lote_codi,
                             p_deta_prec_unit_mmee => v_deta_prec_unit,
                             p_prod_codi_alfa      => '',
                             p_prod_desc           => '');
        end if;
      end loop;
    
      if v_ind_deta = 0 then
        raise_application_error(-20010,
                                'No se encontró detalles en la salida');
      end if;
    end if;
    pp_actualizar_registro;
  exception
    when e_salir then
      null;
  end pp_generar_devolucion;

end i020041;
