
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010082" is

  procedure pp_carga_bloque_habi(p_user_codi in number) is
  
    cursor c_depo is
      select depo_codi, depo_desc from come_depo order by depo_codi;
  
    cursor c_user_depo_orig(p_user_codi in number, p_depo_codi in number) is
      select udor_depo_codi
        from segu_user_depo_orig
       where udor_user_codi = p_user_codi
         and udor_depo_codi = p_depo_codi;
  
    cursor c_user_depo_dest(p_user_codi in number, p_depo_codi in number) is
      select udes_depo_codi
        from segu_user_depo_dest
       where udes_user_codi = p_user_codi
         and udes_depo_codi = p_depo_codi;
  
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DEPO_A_USUA');
    for x in c_depo loop
      apex_collection.add_member(p_collection_name => 'DEPO_A_USUA',
                                 p_c001            => x.depo_codi,
                                 p_c002            => x.depo_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N',
                                 p_c005            => 'N',
                                 p_c006            => 'N');
    
    end loop;
  
    for i in (select seq_id,
                     c001   depo_codi,
                     c002   depo_desc,
                     c003   s_esta_origen,
                     c004   s_esta_ante_origen,
                     c005   s_esta_destino,
                     c006   s_esta_ante_destino
                from apex_collections
               where collection_name = 'DEPO_A_USUA') loop
    
      begin
      
        for x in c_user_depo_orig(p_user_codi, i.depo_codi) loop
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DEPO_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DEPO_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 4,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      
      end;
    
      begin
      
        for x in c_user_depo_dest(p_user_codi, i.depo_codi) loop
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DEPO_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 5,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DEPO_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 6,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      
      end;
    
    end loop;
  end pp_carga_bloque_habi;

  ---------------------------------------------------------------------------------------------------------------------

  procedure pp_actu_regi (p_user in number, p_copiar varchar2 default 'N' ) is
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    
  if p_copiar  = 'N' then
    
    for bdatos in (select seq_id,
                          c001   depo_codi,
                          c002   depo_desc,
                          c003   s_esta_origen,
                          c004   s_esta_ante_origen,
                          c005   s_esta_destino,
                          c006   s_esta_ante_destino
                     from apex_collections
                    where collection_name = 'DEPO_A_USUA') loop
--raise_application_error(-20001,bdatos.s_esta_origen||bdatos.s_esta_ante_origen||bdatos.s_esta_destino||bdatos.s_esta_ante_destino);


      if bdatos.s_esta_origen <> bdatos.s_esta_ante_origen then
         
        --si se marco o desmarc? algo....
        if bdatos.s_esta_origen = 'S' then
          --se marc?, entonces se debe de insertar..
          begin
          insert into segu_user_depo_orig
            (udor_user_codi, udor_depo_codi, udor_base)
          values
            (p_user,bdatos.depo_codi,p_codi_base);
           exception when others then
             raise_application_error(-20001,bdatos.depo_codi||'-'||p_codi_base||'-'||p_user);
           end ;
        elsif bdatos.s_esta_origen = 'N' then
          -- de desmarc?, entonces se debe de borrar
        
          update segu_user_depo_orig
             set udor_base = p_codi_base
           where udor_depo_codi = bdatos.depo_codi
             and udor_user_codi = p_user;
        
          delete segu_user_depo_orig
           where udor_depo_codi = bdatos.depo_codi
             and udor_user_codi = p_user;
        
        end if;
      end if;
    
      if bdatos.s_esta_destino <> bdatos.s_esta_ante_destino then
        
        --si se marco o desmarc? algo....
        if bdatos.s_esta_destino = 'S' then
          --se marc?, entonces se debe de insertar..
          insert into segu_user_depo_dest
            (udes_depo_codi, udes_user_codi, udes_base)
          values
            (bdatos.depo_codi, p_user, p_codi_base);
        elsif bdatos.s_esta_destino = 'N' then
          -- de desmarc?, entonces se debe de borrar
        
          update segu_user_depo_dest
             set udes_base = p_codi_base
           where udes_depo_codi = bdatos.depo_codi
             and udes_user_codi = p_user;
        
          delete segu_user_depo_dest
           where udes_depo_codi = bdatos.depo_codi
             and udes_user_codi = p_user;
        
        end if;
      end if;
    end loop;
    
  else 
    
  
  
  
      delete segu_user_depo_dest
      where udes_user_codi = p_user;
      
      delete segu_user_depo_orig
      where udor_user_codi = p_user;
     

      for bdatos_depo in (select seq_id,
                          c001   depo_codi,
                          c002   depo_desc,
                          c003   s_esta_origen,
                          c004   s_esta_ante_origen,
                          c005   s_esta_destino,
                          c006   s_esta_ante_destino
                     from apex_collections
                    where collection_name = 'DEPO_A_USUA') loop
        if bdatos_depo.s_esta_origen  = 'S' then --se marc¿, entonces se debe de insertar..
            insert into segu_user_depo_orig (udor_user_codi, udor_depo_codi, udor_base) values (p_user , bdatos_depo.depo_codi, p_codi_base);        
        end if;
        
        if bdatos_depo.s_esta_destino = 'S' then --se marc¿, entonces se debe de insertar..
            insert into segu_user_depo_dest (udes_depo_codi, udes_user_codi, udes_base) values (bdatos_depo.depo_codi , p_user, p_codi_base);        
        end if;
        
    
      end loop;
  
  end if;   
    
    
    apex_collection.create_or_truncate_collection(p_collection_name => 'DEPO_A_USUA');
  end pp_actu_regi;
  

end I010082;
