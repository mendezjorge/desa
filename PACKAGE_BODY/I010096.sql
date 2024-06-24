
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010096" is

  procedure pp_cargar_bloque_hab(p_user_codi in number) is

    cursor c_segu_sucu is
      select sucu_codi, sucu_desc, empr_desc
        from come_sucu, come_empr
        where sucu_empr_codi = empr_codi
       order by sucu_codi;

    cursor c_user_sucu(p_user_codi in number, p_sucu_codi in number) is
      select ussu_sucu_codi
        from segu_user_sucu
       where ussu_user_codi = p_user_codi
         and ussu_sucu_codi = p_sucu_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
    for x in c_segu_sucu loop
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => x.sucu_codi,
                                 p_c002            => x.sucu_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N',
                                 p_c005            =>/* x.sucu_empr_codi,
                                 p_c006            => */x.empr_desc);

    end loop;

    for i in (select seq_id,
                     c001   sucu_codi,
                     c002   sucu_desc,
                     c003   s_habilitado,
                     c004   s_habilitado_orig,
                     c005   /*sucu_empr_codi,
                     c006   */empr_desc
                from apex_collections
               where collection_name = 'DETALLE') loop

      begin

        for x in c_user_sucu(p_user_codi, i.sucu_codi) loop

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
  end pp_cargar_bloque_hab;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actualiza_registro is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    for bdatos in (select seq_id,
                          c001   sucu_codi,
                          c002   sucu_desc,
                          c003   s_habilitado,
                          c004   s_habilitado_orig,
                          c005   sucu_empr_codi,
                          c006   empr_desc
                     from apex_collections
                    where collection_name = 'DETALLE') loop

      if bdatos.s_habilitado <> bdatos.s_habilitado_orig then
        --and :babmc_mr.sucu_codi is not null then
        --si se marco o desmarc? algo....
        if bdatos.s_habilitado = 'S' then
          --se marc?, entonces se debe de insertar..
          begin
            insert into segu_user_sucu
              (ussu_user_codi, ussu_sucu_codi, ussu_base)
            values
              (V('P21_USER'), bdatos.sucu_codi, p_codi_base);
          exception
            when others then
              raise_application_error(-20001,
                                      bdatos.sucu_codi || '-' ||
                                      p_codi_base || '-' || V('P21_USER'));
          end;
        elsif bdatos.s_habilitado = 'N' then
          -- de desmarc?, entonces se debe de borrar

          update segu_user_sucu
             set ussu_base = p_codi_base
           where ussu_sucu_codi = bdatos.sucu_codi
             and ussu_user_codi = V('P21_USER');

          delete segu_user_sucu
           where ussu_sucu_codi = bdatos.sucu_codi
             and ussu_user_codi = V('P21_USER');

        end if;
      end if;
    end loop;
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
  end pp_actualiza_registro;

end I010096;
