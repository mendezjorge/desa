
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010015" is

  procedure pp_carga_bloque_habi(p_perf_codi in number,
                                 p_modu_codi in number) is
  
    cursor c_pant is
    /*select pant_codi, pant_desc, pant_desc_abre
            from come_tipo_movi
           order by pant_codi;*/
      select pant_codi, pant_desc, modu_desc, clas_desc
        from segu_clas_pant, segu_pant, segu_modu
       where pant_clas = clas_codi
         and pant_modu = modu_codi
         and (p_modu_codi is null or pant_modu = p_modu_codi)
       order by modu_desc, clas_desc, pant_codi;
  
    cursor c_perf_pant(p_perf_codi in number, p_pant_codi in number) is
      select pape_pant_codi
        from segu_pant_perf
       where pape_perf_codi = p_perf_codi
         and pape_pant_codi = p_pant_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
    for x in c_pant loop
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => x.pant_codi,
                                 p_c002            => x.pant_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N',
                                 p_c005            => x.clas_desc,
                                 p_c006            => x.modu_desc);
    
    end loop;
  
    for i in (select seq_id,
                     c001   pant_codi,
                     c002   pant_desc,
                     c003   s_habilitado,
                     c004   s_estado_orig,
                     c005   clas_desc,
                     c006   modu_desc
                from apex_collections
               where collection_name = 'DETALLE') loop
    
      begin
      
        for x in c_perf_pant(p_perf_codi, i.pant_codi) loop
        
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
  end pp_carga_bloque_habi;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actualizar_registro is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    for bdatos in (select seq_id,
                          c001   pant_codi,
                          c002   pant_desc,
                          c003   s_habilitado,
                          c004   s_estado_orig,
                          c005   clas_desc,
                          c006   modu_desc
                     from apex_collections
                    where collection_name = 'DETALLE') loop
    
      if bdatos.s_habilitado <> bdatos.s_estado_orig then
        --si se marco o desmarc? algo....
        if bdatos.s_habilitado = 'S' then
          --se marc?, entonces se debe de insertar..
          begin
            insert into segu_pant_perf
              (pape_perf_codi, pape_pant_codi, pape_base)
            values
              (V('P25_perf'), bdatos.pant_codi, p_codi_base);
          exception
            when others then
              raise_application_error(-20001,
                                      bdatos.pant_codi || '-' ||
                                      p_codi_base || '-' || V('P25_perf'));
          end;
        elsif bdatos.s_habilitado = 'N' then
          -- de desmarc?, entonces se debe de borrar
        
          update segu_pant_perf
             set pape_base = p_codi_base
           where pape_pant_codi = bdatos.pant_codi
             and pape_perf_codi = V('P25_perf');
        
          delete segu_pant_perf
           where pape_pant_codi = bdatos.pant_codi
             and pape_perf_codi = V('P25_perf');
        
        end if;
      end if;
    end loop;
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
  end pp_actualizar_registro;

end I010015;
