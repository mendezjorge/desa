
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010016" is

  procedure pp_carga_bloque_habi(p_user_codi in number) is
    cursor c_segu_perf is
      select perf_codi, perf_desc from segu_perf order by perf_desc;
  
    cursor c_user_perf(p_user_codi in number, p_perf_codi in number) is
      select uspe_perf_codi
        from segu_user_perf
       where uspe_user_codi = p_user_codi
         and uspe_perf_codi = p_perf_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'PERF_A_USUA');
    for x in c_segu_perf loop
      apex_collection.add_member(p_collection_name => 'PERF_A_USUA',
                                 p_c001            => x.perf_codi,
                                 p_c002            => x.perf_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N');
    
    end loop;
  
    for i in (select seq_id,
                     c001   perf_codi,
                     c002   perf_desc,
                     c003   s_habilitado,
                     c004   s_estado_orig
                from apex_collections
               where collection_name = 'PERF_A_USUA') loop
    
      begin
      
        for x in c_user_perf(p_user_codi, i.perf_codi) loop
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'PERF_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'PERF_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 4,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      
      end;
    
    end loop;
  end pp_carga_bloque_habi;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actualiza_registro(p_user   in number,
                                  p_copiar varchar2 default 'N') is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    if p_copiar = 'N' then
      for bdatos in (select seq_id,
                            c001   perf_codi,
                            c002   perf_desc,
                            c003   s_habilitado,
                            c004   s_estado_orig
                       from apex_collections
                      where collection_name = 'PERF_A_USUA') loop
      
        if bdatos.s_habilitado <> bdatos.s_estado_orig then
          --si se marco o desmarc? algo....
          if bdatos.s_habilitado = 'S' then
            --se marc?, entonces se debe de insertar..
            begin
              insert into segu_user_perf
                (uspe_user_codi, uspe_perf_codi, uspe_base)
              values
                (p_user, bdatos.perf_codi, p_codi_base);
            exception
              when others then
                raise_application_error(-20001,
                                        bdatos.perf_codi || '-' ||
                                        p_codi_base || '-' || p_user);
            end;
          elsif bdatos.s_habilitado = 'N' then
            -- de desmarc?, entonces se debe de borrar
          
            update segu_user_perf
               set uspe_base = p_codi_base
             where uspe_perf_codi = bdatos.perf_codi
               and uspe_user_codi = p_user;
          
            delete segu_user_perf
             where uspe_perf_codi = bdatos.perf_codi
               and uspe_user_codi = p_user;
          
          end if;
        end if;
      end loop;
    
    else
    
      delete segu_user_perf where uspe_user_codi = p_user;
      for bdatos in (select seq_id,
                            c001   perf_codi,
                            c002   perf_desc,
                            c003   s_habilitado,
                            c004   s_estado_orig
                       from apex_collections
                      where collection_name = 'PERF_A_USUA') loop
        if bdatos.s_habilitado = upper('s') then
          insert into segu_user_perf
            (uspe_perf_codi, uspe_user_codi, uspe_base)
          values
            (bdatos.perf_codi, p_user, p_codi_base);
        end if;
      end loop;
    end if;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'PERF_A_USUA');
  end pp_actualiza_registro;

end I010016;
