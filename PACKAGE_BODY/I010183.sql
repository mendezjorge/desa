
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010183" is

  cursor c_det is
    select seq_id,
           c001 tide_asti_codi,
           c002 tide_cuco_codi,
           c003 tide_dbcr,
           c004 tide_desc,
           c005 cuco_nume,
           c006 cuco_desc,
           nvl(c007, 'N') borrar
      from apex_collections
     where collection_name = 'DETALLE';

  procedure pp_carga_detalle(P_ASTI_CODI in number) is

    cursor c_det is
      select f.tide_asti_codi,
             f.tide_cuco_codi,
             f.tide_dbcr,
             f.tide_desc,
             c.cuco_nume,
             c.cuco_desc

        from come_asie_tipo_deta f, come_cuen_cont c
       where c.cuco_codi = f.tide_cuco_codi
         and f.tide_asti_codi = P_ASTI_CODI;

    salir exception;

  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');

    for x in c_det loop
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => x.tide_asti_codi,
                                 p_c002            => x.tide_cuco_codi,
                                 p_c003            => x.tide_dbcr,
                                 p_c004            => x.tide_desc,
                                 p_c005            => x.cuco_nume,
                                 p_c006            => x.cuco_desc);

    end loop;

  end pp_carga_detalle;

  procedure pp_agregar_item(P_TIDE_CUCO_CODI in VARCHAR2,
                            P_TIDE_DBCR      in varchar2,
                            p_tide_desc      IN VARCHAR2,
                            p_cuco_nume      IN VARCHAR2,
                            p_cuco_desc      IN VARCHAR2) is

  begin
    apex_collection.add_member(p_collection_name => 'DETALLE',
                               p_c001            => null,
                               p_c002            => P_TIDE_CUCO_CODI,
                               p_c003            => P_TIDE_DBCR,
                               p_c004            => p_tide_desc,
                               p_c005            => p_cuco_nume,
                               p_c006            => p_cuco_desc,
                               p_c007            => 'N');

  end pp_agregar_item;

  procedure pp_validar_repeticion_nro_cta is
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir      exception;
    v_ant_art  number;
  begin

    -- if v_ant_art = :bdet.tide_cuco_codi then
    raise_application_error(-20001,
                            'El Nro de la Cta. Contable del item ' ||
                            to_char(i) || ' se repite con el del item ' ||
                            to_char(j) ||
                            '. asegurese de no introducir mas de una' ||
                            ' vez el mismo codigo!');
    --   end if;

  exception
    when salir then
      null;
  end;

  procedure pp_actualizar_registro(P_asti_codi in number,
                                   p_asti_desc in varchar2,
                                   p_asti_nomb in varchar2,
                                   p_empr_codi in varchar2) is
    v_asti_codi number;
  begin

    if P_asti_codi is not null then
      v_asti_codi := P_asti_codi;
      update come_asie_tipo
         set asti_desc = p_asti_desc, asti_nomb = p_asti_nomb
       where asti_codi = p_asti_codi;

    else

      begin
        select nvl(max(asti_codi), 0) + 1
          INTO v_asti_codi
          FROM come_asie_tipo;
      end;

      insert into come_asie_tipo
        (asti_codi, asti_desc, asti_base, asti_nomb, asti_empr_codi)
      values
        (v_asti_codi, p_asti_desc, 1, p_asti_nomb, p_empr_codi);
    end if;

    for x in c_det loop

      if x.tide_asti_codi is not null and x.borrar = 'N' then

        update come_asie_tipo_deta
           set tide_asti_codi = x.tide_asti_codi,
               tide_cuco_codi = x.tide_cuco_codi,
               tide_dbcr      = x.tide_dbcr,
               tide_desc      = x.tide_desc
         where tide_asti_codi = x.tide_asti_codi
           and tide_cuco_codi = x.tide_cuco_codi;

      elsif x.tide_asti_codi is null and x.borrar = 'N' then

        insert into come_asie_tipo_deta
          (tide_asti_codi, tide_cuco_codi, tide_dbcr, tide_desc, tide_base)
        values
          (v_asti_codi, x.tide_cuco_codi, x.tide_dbcr, x.tide_desc, 1);

      elsif x.borrar = 'S' then

        delete come_asie_tipo_deta
         where tide_asti_codi = x.tide_asti_codi
           and tide_cuco_codi = x.tide_cuco_codi;

      end if;
    end loop;

  end pp_actualizar_registro;

  procedure pp_borrar_registro(p_ASTI_CODI in number) is
  begin
    ----det
    DELETE FROM come_asie_tipo_deta c WHERE c.TIDE_ASTI_CODI = p_ASTI_CODI;
    ----cab
    delete come_asie_tipo where asti_codi = p_asti_codi;

  end pp_borrar_registro;

end I010183;
