
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010033" is

  procedure pp_carga_bloque_habi(p_user_codi in number,
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
  
    cursor c_user_pant(p_user_codi in number, p_pant_codi in number) is
      select uspa_pant_codi
        from segu_user_pant
       where uspa_user_codi = p_user_codi
         and uspa_pant_codi = p_pant_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'PANT_A_USUA');
    for x in c_pant loop
      apex_collection.add_member(p_collection_name => 'PANT_A_USUA',
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
                     c004   s_habilitadodo_orig,
                     c005   clas_desc,
                     c006   modu_desc
                from apex_collections
               where collection_name = 'PANT_A_USUA') loop
    
      begin
      
        for x in c_user_pant(p_user_codi, i.pant_codi) loop
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'PANT_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'PANT_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 4,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      
      end;
    
    end loop;
  end pp_carga_bloque_habi;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actualizar_registro(p_user   in number,
                                   p_copiar varchar2 default 'N') is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    if p_copiar = 'N' then
      for bdatos in (select seq_id,
                            c001   pant_codi,
                            c002   pant_desc,
                            c003   s_habilitado,
                            c004   s_habilitado_orig,
                            c005   clas_desc,
                            c006   modu_desc
                       from apex_collections
                      where collection_name = 'PANT_A_USUA') loop
      
        if bdatos.s_habilitado <> bdatos.s_habilitado_orig then
          --si se marco o desmarc? algo....
          if bdatos.s_habilitado = 'S' then
            --se marc?, entonces se debe de insertar..
            begin
              insert into segu_user_pant
                (uspa_user_codi, uspa_pant_codi, uspa_base)
              values
                (p_user, bdatos.pant_codi, p_codi_base);
            exception
              when others then
                raise_application_error(-20001,
                                        bdatos.pant_codi || '-' ||
                                        p_codi_base || '-' || p_user);
            end;
          elsif bdatos.s_habilitado = 'N' then
            -- de desmarc?, entonces se debe de borrar
          
            update segu_user_pant
               set uspa_base = p_codi_base
             where uspa_pant_codi = bdatos.pant_codi
               and uspa_user_codi = p_user;
          
            delete segu_user_pant
             where uspa_pant_codi = bdatos.pant_codi
               and uspa_user_codi = p_user;
          
          end if;
        end if;
      end loop;
    else
      delete segu_user_pant where uspa_user_codi = p_user;
      for bdatos in (select seq_id,
                            c001   pant_codi,
                            c002   pant_desc,
                            c003   s_habilitado,
                            c004   s_habilitado_orig,
                            c005   clas_desc,
                            c006   modu_desc
                       from apex_collections
                      where collection_name = 'PANT_A_USUA') loop
        if bdatos.s_habilitado = upper('s') then
          insert into segu_user_pant
            (uspa_pant_codi, uspa_user_codi, uspa_base)
          values
            (bdatos.pant_codi, p_user, p_codi_base);
        end if;
      end loop;
    end if;
    apex_collection.create_or_truncate_collection(p_collection_name => 'PANT_A_USUA');
  end pp_actualizar_registro;

end I010033;
