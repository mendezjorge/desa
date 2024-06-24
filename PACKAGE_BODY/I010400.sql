
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010400" is

  -- Private type declarations
  type r_parameter is record(
    p_validar varchar2(1) := 'S',
    p_codi_base number := 1
  );
    
  parameter r_parameter;
  
  type r_babmc is record(
    SEAL_EMPR_CODI number,
    SEAL_CODI_ALTE varchar2(20),
    SEAL_CODI number,
    SEAL_CLPR_CODI number,
    SEAL_DESC_ABRE varchar2(10),
    SEAL_ULTI_NUME varchar2(10),
    SEAL_ESTA varchar2(1),
    SEAL_BASE number,
    SEAL_USER_REGI varchar2(20),
    SEAL_FECH_REGI date,
    SEAL_USER_MODI varchar2(20),
    SEAL_FECH_MODI date
  );
  babmc r_babmc;
  
  
-----------------------------------------------
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;
  
-----------------------------------------------
  procedure pl_mm(i_mensaje varchar2) is  
  begin
    pl_me(i_mensaje);
  end pl_mm;
  
-----------------------------------------------
  procedure pp_genera_codi_alte(i_empr_codi in number,
                                o_seal_codi_alte out number) is
    
  begin
    select nvl(max(to_number(seal_codi_alte)), 0) + 1
      into o_seal_codi_alte
      from come_clie_secu_alia
     where seal_empr_codi = i_empr_codi;

  exception
    when others then
      null;
      
  end pp_genera_codi_alte;

-----------------------------------------------
  procedure pp_valida_cliente(i_seal_clpr_codi in number) is
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from come_clie_secu_alia
     where seal_clpr_codi = i_seal_clpr_codi
       and seal_esta = 'A'
       and seal_desc_abre <> 'RPY';
    if v_count > 0 then
      pl_me('El Cliente ya cuenta con una secuencia Activa.');
    end if;
  end pp_valida_cliente;

-----------------------------------------------
  procedure pp_validar_cliente(i_clpr_codi_alte in number) is
    
  begin
    
    if parameter.p_validar = 'S' then
      if i_clpr_codi_alte is not null then
        --pp_muestra_come_clie_prov_alte(:babmc.clpr_codi_alte, :babmc.clpr_desc, :babmc.seal_clpr_codi);
        --pp_valida_cliente;
        pp_valida_cliente(i_clpr_codi_alte);  
      end if;
    end if;
    
  end pp_validar_cliente;
  
-----------------------------------------------
  procedure pp_valida is
    v_count number := 0;
  begin
      if babmc.seal_codi_alte is null then
        pl_me('Debe ingresar el código');
      end if; 
              
      if babmc.seal_empr_codi is null then
        pl_me('Debe ingresar el código de Empresa.');
      end if; 
      
      if babmc.seal_desc_abre is null then 
        pl_me('Debe ingresar la descripción');
      end if;
    if babmc.seal_desc_abre <> 'RPY' then
      if babmc.seal_clpr_codi is null then 
        pl_me('Debe ingresar un Cliente');
      end if;
    end if;
    
  end;
  
-----------------------------------------------
  procedure pp_generar_codigo is
  begin
    select nvl(max(seal_codi), 0) + 1
      into babmc.seal_codi
      from come_clie_secu_alia;

  exception
    when no_data_found then
      pl_me('Generación de código incorrecta');
    when too_many_rows then
      pl_me('TOO_MANY_ROWS llame a su administrador');
    when others then
      pl_me('Error al generar codigo! '||sqlerrm);
      
  end pp_generar_codigo;

-----------------------------------------------
  procedure pp_pre_insert is
    
  begin
    
    babmc.seal_user_regi := gen_user;
    babmc.seal_fech_regi := sysdate;
    babmc.seal_base := parameter.p_codi_base;
    babmc.seal_ulti_nume := nvl(babmc.seal_ulti_nume,0);
    pp_generar_codigo;
    
  end;
-----------------------------------------------
  procedure pp_insertar_registro(i_SEAL_CODI_ALTE in varchar2,
                                 i_SEAL_CLPR_CODI in number,
                                 i_SEAL_DESC_ABRE in varchar2,
                                 i_SEAL_ULTI_NUME in varchar2,
                                 i_SEAL_ESTA in varchar2) is
    
  e_insert exception;
  
  begin
    
    babmc.SEAL_CODI_ALTE := i_SEAL_CODI_ALTE;
    babmc.SEAL_CLPR_CODI := i_SEAL_CLPR_CODI;
    babmc.SEAL_DESC_ABRE := i_SEAL_DESC_ABRE;
    babmc.SEAL_ULTI_NUME := i_SEAL_ULTI_NUME;
    babmc.SEAL_ESTA      := i_SEAL_ESTA;
    babmc.seal_empr_codi := V('AI_EMPR_CODI');
    
    pp_valida;
    pp_pre_insert;
    
    --
    begin
      insert into come_clie_secu_alia
       (seal_empr_codi,seal_codi_alte,seal_codi,seal_clpr_codi,seal_desc_abre,seal_ulti_nume,seal_esta,seal_base,seal_user_regi,seal_fech_regi,seal_user_modi,seal_fech_modi)
      values
       (babmc.seal_empr_codi,babmc.seal_codi_alte,babmc.seal_codi,babmc.seal_clpr_codi,babmc.seal_desc_abre,babmc.seal_ulti_nume,babmc.seal_esta,babmc.seal_base,babmc.seal_user_regi,babmc.seal_fech_regi,babmc.seal_user_modi,babmc.seal_fech_modi);
    exception
      when others then
        raise e_insert;
    end;
    --
    
  exception
    when e_insert then
      pl_me('Error al insertar los datos');
    when others then
      pl_me('Error '||sqlerrm);
      
  end pp_insertar_registro;

-----------------------------------------------
  procedure pp_pre_update is
    
  begin
    
    
    
    if babmc.seal_codi is null then 
      pl_me('Error al seleccionar el codigo!');
    end if;
    
    if babmc.seal_desc_abre is null then 
      pl_me('Debe ingresar la descripción');
    end if;
    
    if babmc.seal_desc_abre <> 'RPY' then
      if babmc.seal_clpr_codi is null then 
        pl_me('Debe ingresar un Cliente');
      end if;
    end if;
    
    babmc.seal_user_modi := gen_user;
    babmc.seal_fech_modi := sysdate;
    
  end pp_pre_update;
  
-----------------------------------------------
  procedure pp_update_registro(i_seal_codi in varchar2,
                                 i_seal_clpr_codi in number,
                                 i_seal_desc_abre in varchar2,
                                 i_seal_ulti_nume in varchar2,
                                 i_seal_esta in varchar2) is
    
  e_update exception;
  
  begin
    
    babmc.seal_clpr_codi := i_seal_clpr_codi;
    babmc.seal_desc_abre := i_seal_desc_abre;
    babmc.seal_ulti_nume := i_seal_ulti_nume;
    babmc.seal_esta      := i_seal_esta;
    babmc.seal_codi      := i_seal_codi;
    
    --pp_valida;
    pp_pre_update;
    
    --
    begin
      update come_clie_secu_alia
         set seal_ulti_nume = babmc.seal_ulti_nume,
             seal_clpr_codi = babmc.seal_clpr_codi,
             seal_desc_abre = babmc.seal_desc_abre,
             seal_esta      = babmc.seal_esta,
             seal_user_modi = babmc.seal_user_modi,
             seal_fech_modi = babmc.seal_fech_modi
       where seal_codi = babmc.seal_codi;
    exception
      when others then
        raise e_update;
    end;
    --
    
  exception
    when e_update then
      pl_me('Error al actualizar los datos');
    when others then
      pl_me('Error '||sqlerrm);
      
  end pp_update_registro;

-----------------------------------------------
  procedure pp_send_value is
    
  begin
    
    --setitem('','');
    setitem('P133_SEAL_CODI_ALTE',babmc.seal_codi_alte);
    setitem('P133_CLPR_CODI_ALTE',babmc.seal_clpr_codi);
    setitem('P133_SEAL_DESC_ABRE',babmc.SEAL_DESC_ABRE);
    setitem('P133_SEAL_ULTI_NUME',babmc.SEAL_ULTI_NUME);
    setitem('P133_SEAL_ESTA',babmc.SEAL_ESTA);
    
    setitem('P133_SEAL_USER_REGI',babmc.SEAL_USER_REGI);
    setitem('P133_SEAL_FECH_REGI',babmc.SEAL_FECH_REGI);
    setitem('P133_SEAL_USER_MODI',babmc.SEAL_USER_MODI);
    setitem('P133_SEAL_FECH_MODI',babmc.SEAL_FECH_MODI);
    
    setitem('P133_CLPR_CODI_ALTE_2',babmc.seal_clpr_codi);
    
            
  end pp_send_value;
  
-----------------------------------------------
  procedure pp_ejecutar_consulta(i_seal_codi in number) is

  begin

    select seal_empr_codi, seal_codi_alte, seal_codi, seal_clpr_codi,
            seal_desc_abre, seal_ulti_nume, seal_esta, seal_base,
            seal_user_regi, seal_fech_regi, seal_user_modi, seal_fech_modi
      into babmc.seal_empr_codi, babmc.seal_codi_alte, babmc.seal_codi,
            babmc.seal_clpr_codi, babmc.seal_desc_abre, babmc.seal_ulti_nume,
            babmc.seal_esta, babmc.seal_base, babmc.seal_user_regi,
            babmc.seal_fech_regi, babmc.seal_user_modi, babmc.seal_fech_modi
    from come_clie_secu_alia 
     where seal_codi = i_seal_codi
     and seal_empr_codi = v('AI_EMPR_CODI');
     
     --pl_me('i_seal_codi: '||i_seal_codi);
     
     pp_send_value;

  /*Exception
    When no_data_found then
      pl_me('No se ha encontrado ningun registro');*/
    
  end pp_ejecutar_consulta;

-----------------------------------------------
  procedure pp_delete_registro(i_seal_codi in varchar2) is
    
  e_delete exception;
  
  begin
    
    if i_seal_codi is null then
      pl_me('El codigo esta vacio!');
    end if;
      
    --
    begin
       delete come_clie_secu_alia
       where seal_codi = i_seal_codi;
    exception
      when others then
        raise e_delete;
    end;
    --
    
  exception
    when e_delete then
      pl_me('Error al eliminar el registro');
    when others then
      pl_me('Error '||sqlerrm);
      
  end pp_delete_registro;

  
  
end I010400;
