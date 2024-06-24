
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010042" is
  type r_parameter is record(
    p_where  varchar2(500),
    p_report varchar2(20) := 'I010042',
    p_titulo varchar2(50) := 'I010042 - Asignacion de Operaciones a Usuarios');

  parameter r_parameter;

  procedure pp_carga_bloque_habi(p_user_codi in number) is
  
    cursor c_timo is
      select oper_codi, oper_desc, oper_desc_abre
        from come_stoc_oper
       order by oper_codi;
  
    cursor c_user_stoc_oper(p_user_codi in number, p_oper_codi in number) is
      select usop_oper_codi
        from segu_user_stoc_oper
       where usop_user_codi = p_user_codi
         and usop_oper_codi = p_oper_codi;
    salir exception;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'OPER_A_USUA');
    for x in c_timo loop
      apex_collection.add_member(p_collection_name => 'OPER_A_USUA',
                                 p_c001            => x.oper_codi,
                                 p_c002            => x.oper_desc,
                                 p_c003            => 'N',
                                 p_c004            => 'N',
                                 p_c005            => x.oper_desc_abre);
    
    end loop;
  
    for i in (select seq_id,
                     c001   oper_codi,
                     c002   oper_desc,
                     c003   s_esta,
                     c004   s_esta_ante_,
                     c005   oper_desc_abre
                from apex_collections
               where collection_name = 'OPER_A_USUA') loop
    
      begin
      
        for x in c_user_stoc_oper(p_user_codi, i.oper_codi) loop
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'OPER_A_USUA',
                                                  P_SEQ             => i.seq_id,
                                                  P_ATTR_NUMBER     => 3,
                                                  P_ATTR_VALUE      => 'S');
        
          APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'OPER_A_USUA',
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
                            c001   oper_codi,
                            c002   oper_desc,
                            c003   s_esta,
                            c004   s_esta_ante,
                            c005   oper_desc_abre
                       from apex_collections
                      where collection_name = 'OPER_A_USUA') loop
      
        if bdatos.s_esta <> bdatos.s_esta_ante then
          --si se marco o desmarc? algo....
          if bdatos.s_esta = 'S' then
            --se marc?, entonces se debe de insertar..
            begin
              insert into segu_user_stoc_oper
                (usop_user_codi, usop_oper_codi, usop_base)
              values
                (p_user, bdatos.oper_codi, p_codi_base);
            exception
              when others then
                raise_application_error(-20001,
                                        bdatos.oper_codi || '-' ||
                                        p_codi_base || '-' || p_user);
            end;
          elsif bdatos.s_esta = 'N' then
            -- de desmarc?, entonces se debe de borrar
          
            update segu_user_stoc_oper
               set usop_base = p_codi_base
             where usop_oper_codi = bdatos.oper_codi
               and usop_user_codi = p_user;
          
            delete segu_user_stoc_oper
             where usop_oper_codi = bdatos.oper_codi
               and usop_user_codi = p_user;
          
          end if;
        end if;
      end loop;
    else
      delete segu_user_stoc_oper where usop_user_codi = p_user;
      for bdatos in (select seq_id,
                            c001   oper_codi,
                            c002   oper_desc,
                            c003   s_esta,
                            c004   s_esta_ante,
                            c005   oper_desc_abre
                       from apex_collections
                      where collection_name = 'OPER_A_USUA') loop
        if bdatos.s_esta = 'S' then
          --se marc¿, entonces se debe de insertar..
          insert into segu_user_stoc_oper
            (usop_oper_codi, usop_user_codi, usop_base)
          values
            (bdatos.oper_codi,
             p_user,
             p_codi_base);
        end if;
      end loop;
    end if;
    apex_collection.create_or_truncate_collection(p_collection_name => 'OPER_A_USUA');
  end pp_actu_regi;
  
  ---------------------------------------------------------------------------------  
  
  procedure pp_llama_reporte(i_user_codi in number,
                             i_user_desc in varchar2) is
    v_parametros   CLOB;
    v_contenedores CLOB;
  begin
    parameter.p_where := 'where su.user_codi=' || i_user_codi;
    v_contenedores    := 'p_title:p_where:p_codigo:p_usuario';
  
    v_parametros := parameter.p_titulo || ':' || parameter.p_where || ':' ||
                    i_user_codi || ':' || i_user_desc;
  
    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;
  
    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, gen_user, parameter.p_report, 'pdf', V_CONTENEDORES);
  
    commit;
  end pp_llama_reporte;

end I010042;
