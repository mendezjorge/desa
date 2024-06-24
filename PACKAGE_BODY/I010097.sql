
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010097" is

  procedure pp_carga_bloque_hab(p_user_codi in number) is
    cursor c_segu_empr is
      select empr_codi, empr_desc from come_empr order by empr_codi;

    cursor c_user_perf(p_user_codi in number, p_empr_codi in number) is
      select usem_empr_codi
        from segu_user_empr
       where usem_user_codi = p_user_codi
         and usem_empr_codi = p_empr_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
    for x in c_segu_empr loop
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => x.empr_codi,
                                 p_c002            => x.empr_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N');

    end loop;

    for i in (select seq_id,
                     c001   empr_codi,
                     c002   empr_desc,
                     c003   s_habilitado,
                     c004   s_estado_orig
                from apex_collections
               where collection_name = 'DETALLE') loop

      begin

        for x in c_user_perf(p_user_codi, i.empr_codi) loop

          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DETALLE',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');

          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DETALLE',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 4,
                                                  P_ATTR_VALUE      => 'S');

        end loop;

      end;

    end loop;
  end pp_carga_bloque_hab;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actualiza_registro is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    for bdatos in (select seq_id,
                          c001   empr_codi,
                          c002   empr_desc,
                          c003   s_habilitado,
                          c004   s_estado_orig
                     from apex_collections
                    where collection_name = 'DETALLE') loop

      if bdatos.s_habilitado <> bdatos.s_estado_orig then
        --si se marco o desmarc? algo....
        if bdatos.s_habilitado = 'S' then
          --se marc?, entonces se debe de insertar..
          begin
            insert into segu_user_empr
              (usem_user_codi, usem_empr_codi, usem_base)
            values
              (V('P20_USER'), bdatos.empr_codi, p_codi_base);
          exception
            when others then
              raise_application_error(-20001,
                                      bdatos.empr_codi || '-' ||
                                      p_codi_base || '-' || V('P20_USER'));
          end;
        elsif bdatos.s_habilitado = 'N' then
          -- de desmarc?, entonces se debe de borrar

          update segu_user_empr
             set usem_base = p_codi_base
           where usem_empr_codi = bdatos.empr_codi
             and usem_user_codi = V('P20_USER');

          delete segu_user_empr
           where usem_empr_codi = bdatos.empr_codi
             and usem_user_codi = V('P20_USER');

        end if;
      end if;
    end loop;
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
  end pp_actualiza_registro;

end I010097;
