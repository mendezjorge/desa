
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010099" is

  p_peri_actu number := fa_busc_para('p_codi_peri_actu');
  p_peri_sgte number := fa_busc_para('p_codi_peri_sgte');

  p_codi_mone_mmee number := to_number(fa_busc_para('p_codi_mone_mmee'));
  p_codi_mone_mmnn number := to_number(fa_busc_para('p_codi_mone_mmnn'));

  procedure pp_carga_cost_prom(p_lote_codi in number,
                               p_peri_codi in number,
                               p_cost      out number,
                               p_cost_mmee out number) is
  begin

    select pelo_cost_fini_mmnn, pelo_cost_fini_mmee
      into p_cost, p_cost_mmee
      from come_prod_peri_lote
     where pelo_lote_codi = p_lote_codi
       and pelo_peri_codi = p_peri_codi;

  exception
    when no_data_found then
      p_cost      := 0;
      p_cost_mmee := 0;
    when others then
      p_cost      := 0;
      p_cost_mmee := 0;
  end;

  procedure pp_busca_tasa_mmee(p_mone_codi in number,
                               p_mone_coti out number) is
  begin

    if p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    else

      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_tica_codi = 1
         and coti_fech = trunc(sysdate);

    end if;

  exception
    when no_data_found then
      p_mone_coti := null;
      raise_application_error(-20010,
                              'Cotizaciion Inexistente para la moneda extranjera  ' ||
                              p_codi_mone_mmee);
    when others then
      raise_application_error(-20010,
                              'Error al momento de buscar tasa  ' ||
                              p_codi_mone_mmee);

  end;

  procedure pp_muestra_desc_peri(p_peri_codi in number,
                                 p_peri_desc out char) is
  begin
    select to_char(peri_fech_inic, 'MM/YYYY') mes_anho
      into p_peri_desc
      from come_peri
     where peri_codi = p_peri_codi;

  exception
    when others then
      p_peri_desc := null;

  end;

  procedure pp_mostrar_lote(p_lote_codi in number,
                            p_lote_desc out varchar2,
                            p_prod_codi in number) is

    v_lote_prod_codi number;

  begin

    select lote_desc, lote_prod_codi
      into p_lote_desc, v_lote_prod_codi
      from come_lote
     where lote_codi = p_lote_codi;

    if v_lote_prod_codi <> p_prod_codi then
      raise_application_error(-20010, 'El lote no corresponde al producto');
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Lote inexistente');

  end;

  procedure pp_actualizar_registro(i_prod_codi      in number,
                                   i_cost_prom      in number,
                                   i_cost_prom_mmee in number,
                                   i_coti_mmee      in number,
                                   i_lote_codi      in number,
                                   i_prod_indi_lote in varchar2) is
  begin

    if i_prod_codi is not null and i_cost_prom is not null and
       i_lote_codi is not null then

      pp_actu_cost_prom(i_prod_codi,
                        i_cost_prom,
                        i_cost_prom_mmee,
                        i_coti_mmee,
                        i_lote_codi,
                        NVL(i_prod_indi_lote, 'N'));

      --pp_actu_prec(i_prod_codi, i_cost_prom, i_cost_prom_mmee);

    else
      if i_prod_codi is null then
        raise_application_error(-20010,
                                'Primero debe ingresar el codigo del producto ');
      end if;

      if i_cost_prom_mmee is null then
        raise_application_error(-20010,
                                'Primero debe ingresar el costo promedio en mmee del producto seleccionado... ');
      end if;

      if i_cost_prom is null then
        raise_application_error(-20010,
                                'Primero debe ingresar el costo promedio en mmnn del producto seleccionado... ');
      end if;

    end if;

  end;

  --actualiar el costo promedio del periodo actual y siguiente...
  procedure pp_actu_cost_prom(p_prod_codi      in number,
                              p_cost_prom      in number,
                              p_cost_prom_mmee in number,
                              p_tasa_mmee      in number,
                              p_lote_codi      in number,
                              p_prod_indi_lote in varchar2) is


    v_count          number;

  begin

    ---solo si el producto es no loteable, se actualiza el costo promedio del producto
    if NVL(p_prod_indi_lote, 'N') = 'N' then

      update come_prod_peri
         set prpe_cost_prom_fini_mmnn = p_cost_prom,
             prpe_cost_prom_fini_mmee = p_cost_prom_mmee
       where prpe_prod_codi = p_prod_codi
         and prpe_peri_codi = p_peri_actu;

      update come_prod_peri
         set prpe_cost_prom_inic_mmnn = p_cost_prom,
             prpe_cost_prom_fini_mmnn = p_cost_prom,
             prpe_cost_prom_inic_mmee = p_cost_prom_mmee,
             prpe_cost_prom_fini_mmee = p_cost_prom_mmee
       where prpe_prod_codi = p_prod_codi
         and prpe_peri_codi = p_peri_sgte;

      ------------------------------------------------------------------
      --actualizar para dejar registro del costo ingresado manualmente--
      ------------------------------------------------------------------
      begin
        select count(*)
          into v_count
          from come_prod_cost_mens
         where prco_prod_codi = p_prod_codi
           and prco_peri_codi = p_peri_actu;

        if v_count = 0 then
          insert into come_prod_cost_mens
            (prco_prod_codi,
             prco_peri_codi,
             prco_cost_mmnn,
             prco_cost_mmee,
             prco_tasa_mmee,
             prco_user_regi,
             prco_fech_regi)
          values
            (p_prod_codi,
             p_peri_actu,
             p_cost_prom,
             p_cost_prom_mmee,
             p_tasa_mmee,
             fp_user,
             sysdate);
        else
          update come_prod_cost_mens
             set prco_cost_mmnn = p_cost_prom,
                 prco_cost_mmee = p_cost_prom_mmee,
                 prco_user_modi = fp_user,
                 prco_fech_modi = sysdate
           where prco_prod_codi = p_prod_codi
             and prco_peri_codi = p_peri_actu;
        end if;
      end;

    end if;

    ------------------------------------------------------------
    --actualizar el costo promedio por lote
    ------------------------------------------------------------

    update come_prod_peri_lote
       set pelo_cost_fini_mmnn = p_cost_prom,
           pelo_cost_fini_mmee = p_cost_prom_mmee
     where pelo_prod_codi = p_prod_codi
       and pelo_peri_codi = p_peri_actu
       and pelo_lote_codi = p_lote_codi;

    update come_prod_peri_lote
       set pelo_cost_inic_mmnn = p_cost_prom,
           pelo_cost_fini_mmnn = p_cost_prom,
           pelo_cost_inic_mmee = p_cost_prom_mmee,
           pelo_cost_fini_mmee = p_cost_prom_mmee
     where pelo_prod_codi = p_prod_codi
       and pelo_peri_codi = p_peri_sgte
       and pelo_lote_codi = p_lote_codi;

    begin
      select count(*)
        into v_count
        from come_prod_cost_mens_lote
       where prco_prod_codi = p_prod_codi
         and prco_peri_codi = p_peri_actu
         and prco_lote_codi = p_lote_codi;

      if v_count = 0 then
        insert into come_prod_cost_mens_lote
          (prco_prod_codi,
           prco_peri_codi,
           prco_cost_mmnn,
           prco_cost_mmee,
           prco_tasa_mmee,
           prco_user_regi,
           prco_fech_regi,
           prco_lote_Codi)
        values
          (p_prod_codi,
           p_peri_actu,
           p_cost_prom,
           p_cost_prom_mmee,
           p_tasa_mmee,
           fp_user,
           sysdate,
           p_lote_codi);
      else
        update come_prod_cost_mens_lote
           set prco_cost_mmnn = p_cost_prom,
               prco_cost_mmee = p_cost_prom_mmee,
               prco_user_modi = fp_user,
               prco_fech_modi = sysdate
         where prco_prod_codi = p_prod_codi
           and prco_lote_codi = p_lote_codi
           and prco_peri_codi = p_peri_actu;
      end if;
    end;

    ------------------------------------------------------------------

  end;



end I010099;
