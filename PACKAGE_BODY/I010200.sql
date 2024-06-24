
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010200" is

  procedure pp_carga_bloque_habi(p_user_codi in number) is
  
    cursor c_cuen is
      select cuen_codi, cuen_desc from come_cuen_banc order by cuen_codi;
  
    cursor c_user_cuen_cons(p_user_codi in number, p_cuen_codi in number) is
      select USCB_cuen_codi
        from segu_user_cuen_banc
       where USCB_user_codi = p_user_codi
         and USCB_cuen_codi = p_cuen_codi;
  
    cursor c_user_cuen_debi(p_user_codi in number, p_cuen_codi in number) is
      select uscd_cuen_codi
        from segu_user_cuen_dest
       where uscd_user_codi = p_user_codi
         and uscd_cuen_codi = p_cuen_codi;
  
    cursor c_user_cuen_cred(p_user_codi in number, p_cuen_codi in number) is
      select usco_cuen_codi
        from segu_user_cuen_orig
       where usco_user_codi = p_user_codi
         and usco_cuen_codi = p_cuen_codi;
  
    salir exception;
  begin
    --raise_application_error(-20010, p_user_codi);
    apex_collection.create_or_truncate_collection(p_collection_name => 'CAJA_A_USUA');
    for x in c_cuen loop
      apex_collection.add_member(p_collection_name => 'CAJA_A_USUA',
                                 p_c001            => x.cuen_codi, --apli_codigo,
                                 p_c002            => x.cuen_desc, --apli_fecha,
                                 p_c003            => 'N',
                                 p_c004            => 'N',
                                 p_c005            => 'N',
                                 p_c006            => 'N',
                                 p_c007            => 'N',
                                 p_c008            => 'N');
    end loop;
  
    --Este es el for principal para recorrer
    for i in (select seq_id,
                     c001   cuen_codi,
                     c002   cuen_desc,
                     c003   s_esta_cons,
                     c004   s_esta_ante_cons,
                     c005   s_esta_debi,
                     c006   s_esta_ante_debi,
                     c007   s_esta_cred,
                     c008   s_esta_ante_cred
                from apex_collections
               where collection_name = 'CAJA_A_USUA') loop
    
      begin
        for x in c_user_cuen_cons(p_user_codi, i.cuen_codi) loop
          --raise_application_error(-20010, p_user_codi);
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'CAJA_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'CAJA_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 4,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      end;
    
      begin
        for x in c_user_cuen_debi(p_user_codi, i.cuen_codi) loop
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'CAJA_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 5,
                                                  P_ATTR_VALUE      => 'S');
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'CAJA_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 6,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      end;
    
      begin
      
        for x in c_user_cuen_cred(p_user_codi, i.cuen_codi) loop
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'CAJA_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 7,
                                                  P_ATTR_VALUE      => 'S');
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'CAJA_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 8,
                                                  P_ATTR_VALUE      => 'S');
        
        end loop;
      
      end;
    
    end loop;
  
  end;

  ---------------------------------------------------------------------------------------------------

  procedure pp_actu_regi (p_user in number, p_copiar varchar2 default 'N') is
  
    p_codi_base number := pack_repl.fa_devu_codi_base;
    v_estado    varchar2(10);
  begin
    
  if p_copiar = 'N' then
    for bdatos in (select seq_id,
                          c001   cuen_codi,
                          c002   cuen_desc,
                          c003   s_esta_cons,
                          c004   s_esta_ante_cons,
                          c005   s_esta_debi,
                          c006   s_esta_ante_debi,
                          c007   s_esta_cred,
                          c008   s_esta_ante_cred
                     from apex_collections
                    where collection_name = 'CAJA_A_USUA') loop
    
      if bdatos.s_esta_cons <> bdatos.s_esta_ante_cons then
        --si se marco o desmarc? algo....
        if bdatos.s_esta_cons = 'S' then
          --se marc?, entonces se debe de insertar..
          insert into segu_user_cuen_banc
            (uscb_cuen_codi, uscb_user_codi, uscb_base)
          values
            (bdatos.cuen_codi, p_user, p_codi_base);
        elsif bdatos.s_esta_cons = 'N' then
          -- de desmarc?, entonces se debe de borrar
        
          update segu_user_cuen_banc
             set uscb_base = p_codi_base
           where uscb_cuen_codi = bdatos.cuen_codi
             and uscb_user_codi = p_user;
        
          delete segu_user_cuen_banc
           where uscb_cuen_codi = bdatos.cuen_codi
             and uscb_user_codi = p_user;
        
        end if;
      end if;
    
      if bdatos.s_esta_debi <> bdatos.s_esta_ante_debi then
        --si se marco o desmarc? algo....
        if bdatos.s_esta_debi = 'S' then
          --se marc?, entonces se debe de insertar..
          insert into segu_user_cuen_dest
            (uscd_cuen_codi, uscd_user_codi, uscd_base)
          values
            (bdatos.cuen_codi, p_user, p_codi_base);
        elsif bdatos.s_esta_debi = 'N' then
          -- de desmarc?, entonces se debe de borrar
        
          update segu_user_cuen_dest
             set uscd_base = p_codi_base
           where uscd_cuen_codi = bdatos.cuen_codi
             and uscd_user_codi = p_user;
        
          delete segu_user_cuen_dest
           where uscd_cuen_codi = bdatos.cuen_codi
             and uscd_user_codi = p_user;
        
        end if;
      end if;
    
      if bdatos.s_esta_cred <> bdatos.s_esta_ante_cred then
        --si se marco o desmarc? algo....
        if bdatos.s_esta_cred = 'S' then
          --se marc?, entonces se debe de insertar..
          insert into segu_user_cuen_orig
            (usco_cuen_codi, usco_user_codi, usco_base)
          values
            (bdatos.cuen_codi, p_user, p_codi_base);
        elsif bdatos.s_esta_cred = 'N' then
          -- de desmarc?, entonces se debe de borrar
        
          update segu_user_cuen_orig
             set usco_base = p_codi_base
           where usco_cuen_codi = bdatos.cuen_codi
             and usco_user_codi = p_user;
        
          delete segu_user_cuen_orig
           where usco_cuen_codi = bdatos.cuen_codi
             and usco_user_codi = p_user;
        
        end if;
      end if;
    
    end loop;
    
  else
  
  
    delete segu_user_cuen_banc
    where uscb_user_codi = p_user; 
    
    delete segu_user_cuen_dest
    where uscd_user_codi = p_user;
    
    delete segu_user_cuen_orig
    where usco_user_codi = p_user; 
    
 

     for bdatos in (select seq_id,
                          c001   cuen_codi,
                          c002   cuen_desc,
                          c003   s_esta_cons,
                          c004   s_esta_ante_cons,
                          c005   s_esta_debi,
                          c006   s_esta_ante_debi,
                          c007   s_esta_cred,
                          c008   s_esta_ante_cred
                     from apex_collections
                    where collection_name = 'CAJA_A_USUA') loop
                    
      if bdatos.s_esta_cons = 'S' then --se marc?, entonces se debe de insertar..
           insert into segu_user_cuen_banc (uscb_cuen_codi, uscb_user_codi, uscb_base) values (bdatos.cuen_codi , p_user, p_codi_base);       
      end if;
      
      if bdatos.s_esta_debi = 'S' then --se marc?, entonces se debe de insertar..
           insert into segu_user_cuen_dest (uscd_cuen_codi, uscd_user_codi, uscd_base) values (bdatos.cuen_codi , p_user, p_codi_base);       
      end if;
      
      if bdatos.s_esta_cred = 'S' then --se marc?, entonces se debe de insertar..
           insert into segu_user_cuen_orig (usco_cuen_codi, usco_user_codi, usco_base) values (bdatos.cuen_codi , p_user, p_codi_base);       
      end if;
      

    end loop;
        end if;    
    
    apex_collection.create_or_truncate_collection(p_collection_name => 'CAJA_A_USUA');
  
  end;

end I010200;
