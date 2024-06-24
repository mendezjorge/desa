
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010043" is

  procedure pp_carga_bloque_habi(p_user_codi in number) is
  
    cursor c_timo is
      select timo_codi, timo_desc, timo_desc_abre
        from come_tipo_movi
       order by timo_codi;
  
    cursor c_user_timo(p_user_codi in number, p_timo_codi in number) is
      select usmo_timo_codi
        from segu_user_tipo_movi
       where usmo_user_codi = p_user_codi
         and usmo_timo_codi = p_timo_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'TIPO_MOV_A_USUA');
    for x in c_timo loop
      apex_collection.add_member(p_collection_name => 'TIPO_MOV_A_USUA',
                                 p_c001            => x.timo_codi,
                                 p_c002            => x.timo_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N',
                                 p_c005            => x.timo_desc_abre);
    
    end loop;
  
    for i in (select seq_id,
                     c001   timo_codi,
                     c002   timo_desc,
                     c003   s_esta,
                     c004   s_esta_ante_,
                     c005   timo_desc_abre
                from apex_collections
               where collection_name = 'TIPO_MOV_A_USUA') loop
    
      begin
      
        for x in c_user_timo(p_user_codi, i.timo_codi) loop
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'TIPO_MOV_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'TIPO_MOV_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 4,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      
      end;
    
    end loop;
  end pp_carga_bloque_habi;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actu_regi(p_user in number, p_copiar varchar2 default 'N') is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    if p_copiar = 'N' then
      for bdatos in (select seq_id,
                            c001   timo_codi,
                            c002   timo_desc,
                            c003   s_esta,
                            c004   s_esta_ante,
                            c005   timo_desc_abre
                       from apex_collections
                      where collection_name = 'TIPO_MOV_A_USUA') loop
      
        if bdatos.s_esta <> bdatos.s_esta_ante then
          --si se marco o desmarc? algo....
          if bdatos.s_esta = 'S' then
            --se marc?, entonces se debe de insertar..
            begin
              insert into segu_user_tipo_movi
                (usmo_user_codi, usmo_timo_codi, usmo_base)
              values
                (p_user, bdatos.timo_codi, p_codi_base);
            exception
              when others then
                raise_application_error(-20001,
                                        bdatos.timo_codi || '-' ||
                                        p_codi_base || '-' || p_user);
            end;
          elsif bdatos.s_esta = 'N' then
            -- de desmarc?, entonces se debe de borrar
          
            update segu_user_tipo_movi
               set usmo_base = p_codi_base
             where usmo_timo_codi = bdatos.timo_codi
               and usmo_user_codi = p_user;
          
            delete segu_user_tipo_movi
             where usmo_timo_codi = bdatos.timo_codi
               and usmo_user_codi = p_user;
          
          end if;
        end if;
      end loop;
    
    else
    
      delete segu_user_tipo_movi where usmo_user_codi = p_user;
    
      for bdatos in (select seq_id,
                            c001   timo_codi,
                            c002   timo_desc,
                            c003   s_esta,
                            c004   s_esta_ante,
                            c005   timo_desc_abre
                       from apex_collections
                      where collection_name = 'TIPO_MOV_A_USUA') loop
      
        if bdatos.s_esta = 'S' then
          --se marc?, entonces se debe de insertar..
          insert into segu_user_tipo_movi
            (usmo_timo_codi, usmo_user_codi, usmo_base)
          values
            (bdatos.timo_codi, p_user, p_codi_base);
        end if;
      end loop;
    end if;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'TIPO_MOV_A_USUA');
  end pp_actu_regi;

end I010043;
