
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010032" is
  e_retornar exception;
  e_error    exception;
  e_salir    exception;
  e_show_lov exception;
  procedure pp_genera_codi(o_oper_codi out number) is
  begin
    select nvl(max(o.oper_codi), 0) + 1
      into o_oper_codi
      from come_stoc_oper o
     where o.oper_empr_codi = nvl(v('AI_EMPR_CODI'), 1);
  end;

  procedure pp_actualizar_regsitro(p_oper_indicador           in varchar2,
                                   p_oper_codi                in come_stoc_oper.oper_codi%type,
                                   p_oper_desc                in come_stoc_oper.oper_desc%type,
                                   p_oper_desc_abre           in come_stoc_oper.oper_desc_abre%type,
                                   p_oper_stoc_suma_rest      in come_stoc_oper.oper_stoc_suma_rest%type,
                                   p_oper_grop_codi           in come_stoc_oper.oper_grop_codi%type,
                                   p_oper_indi_valo_cost      in come_stoc_oper.oper_indi_valo_cost%type,
                                   p_oper_cuco_codi_debe      in come_stoc_oper.oper_cuco_codi_debe%type,
                                   p_oper_cuco_codi_habe      in come_stoc_oper.oper_cuco_codi_habe%type,
                                   p_oper_cuco_dife_cost      in come_stoc_oper.oper_cuco_dife_cost%type,
                                   p_oper_nive_cost           in come_stoc_oper.oper_nive_cost%type,
                                   p_oper_stoc_afec_cost_prom in come_stoc_oper.oper_stoc_afec_cost_prom%type,
                                   p_oper_indi_gene_asie_stoc in come_stoc_oper.oper_indi_gene_asie_stoc%type,
                                   p_oper_indi_oper_vari      in come_stoc_oper.oper_indi_oper_vari%type,
                                   p_oper_indi_asie_prod      in come_stoc_oper.oper_indi_asie_prod%type,
                                   p_oper_user_regi           in come_stoc_oper.oper_user_regi%type,
                                   p_oper_fech_regi           in come_stoc_oper.oper_fech_regi%type,
                                   p_oper_user_modi           in come_stoc_oper.oper_user_modi%type,
                                   p_oper_fech_modi           in come_stoc_oper.oper_fech_modi%type) as
  begin
  
    if p_oper_indicador = 'N' then
    
      -- Insercion
      insert into come_stoc_oper
        (oper_codi,
         oper_desc,
         oper_desc_abre,
         oper_stoc_suma_rest,
         oper_grop_codi,
         oper_indi_valo_cost,
         oper_cuco_codi_debe,
         oper_cuco_codi_habe,
         oper_cuco_dife_cost,
         oper_nive_cost,
         oper_stoc_afec_cost_prom,
         oper_indi_gene_asie_stoc,
         oper_indi_oper_vari,
         oper_indi_asie_prod,
         oper_user_regi,
         oper_fech_regi,
         oper_empr_codi)
      values
        (p_oper_codi,
         p_oper_desc,
         p_oper_desc_abre,
         p_oper_stoc_suma_rest,
         p_oper_grop_codi,
         p_oper_indi_valo_cost,
         p_oper_cuco_codi_debe,
         p_oper_cuco_codi_habe,
         p_oper_cuco_dife_cost,
         p_oper_nive_cost,
         p_oper_stoc_afec_cost_prom,
         p_oper_indi_gene_asie_stoc,
         p_oper_indi_oper_vari,
         p_oper_indi_asie_prod,
         p_oper_user_regi,
         p_oper_fech_regi,
         nvl(v('AI_EMPR_CODI'), 1));
    
    elsif p_oper_indicador = 'U' then
    
      -- Modificacion
      update come_stoc_oper
         set oper_desc                = p_oper_desc,
             oper_desc_abre           = p_oper_desc_abre,
             oper_stoc_suma_rest      = p_oper_stoc_suma_rest,
             oper_grop_codi           = p_oper_grop_codi,
             oper_indi_valo_cost      = p_oper_indi_valo_cost,
             oper_cuco_codi_debe      = p_oper_cuco_codi_debe,
             oper_cuco_codi_habe      = p_oper_cuco_codi_habe,
             oper_cuco_dife_cost      = p_oper_cuco_dife_cost,
             oper_nive_cost           = p_oper_nive_cost,
             oper_stoc_afec_cost_prom = p_oper_stoc_afec_cost_prom,
             oper_indi_gene_asie_stoc = p_oper_indi_gene_asie_stoc,
             oper_indi_oper_vari      = p_oper_indi_oper_vari,
             oper_indi_asie_prod      = p_oper_indi_asie_prod,
             oper_user_regi           = p_oper_user_regi,
             oper_fech_regi           = p_oper_fech_regi,
             oper_user_modi           = p_oper_user_modi,
             oper_fech_modi           = p_oper_fech_modi
       where oper_codi = p_oper_codi
         and oper_empr_codi = nvl(v('AI_EMPR_CODI'), 1);
    
    elsif p_oper_indicador = 'D' then
    
      delete come_stoc_oper
       where oper_codi = p_oper_codi
         and oper_empr_codi = nvl(v('AI_EMPR_CODI'), 1);
    
    end if;
  
  end pp_actualizar_regsitro;

  procedure pp_busqueda_grupo(p_busc_dato       in varchar2,
                              p_oper_grop_codi  out varchar2,
                              p_indi_list_value out number) is
  
    salir  exception;
    v_cant number;
  
    function fi_buscar_grop_codi(p_busc_dato      in varchar2,
                                 p_oper_grop_codi out varchar2)
      return boolean is
    begin
      select mo.grop_codi
        into p_oper_grop_codi
        from come_oper_stoc_grup mo
       where mo.grop_codi = p_busc_dato;
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
    function fi_buscar_grop_desc(p_busc_dato      in varchar2,
                                 p_oper_grop_codi out varchar2)
      return boolean is
    begin
      select mo.grop_codi
        into p_oper_grop_codi
        from come_oper_stoc_grup mo
       where upper(mo.grop_desc) = upper(p_busc_dato);
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
  begin
    --buscar grupo por codigo de alternativo
    if fi_buscar_grop_codi(p_busc_dato, p_oper_grop_codi) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    --buscar grupo por descripcion
    if fi_buscar_grop_desc(p_busc_dato, p_oper_grop_codi) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    begin
      select count(*)
        into v_cant
        from come_oper_stoc_grup mo
       where (upper(mo.grop_codi) like '%' || p_busc_dato || '%' or
             upper(mo.grop_desc) like '%' || p_busc_dato || '%');
    end;
  
    if v_cant > 1 then
      --si existe al menos una grupo con esos criterios entonces mostrar la lista      
      setitem('P60_OPER_GROP_CODI', null);
      p_oper_grop_codi  := p_busc_dato;
      p_indi_list_value := 1;
    else
      p_oper_grop_codi  := p_busc_dato;
      p_indi_list_value := 1;
    end if;
  
  exception
    when salir then
      p_indi_list_value := 0;
    when others then
      raise_application_error(-20001, 'error: ' || sqlerrm);
  end pp_busqueda_grupo;

  procedure pp_mostrar_grupo(P_OPER_GROP_CODI in VARCHAR2,
                             P_GROP_DESC      out varchar2) is
  begin
    select grop_desc
      into P_GROP_DESC
      from come_oper_stoc_grup
     where grop_codi = P_OPER_GROP_CODI;
  exception
    when others then
      raise_application_error(-20001,
                              'Error ' || sqlerrm || ' THIS IS A PROBLEM ' ||
                              P_OPER_GROP_CODI);
  end pp_mostrar_grupo;

  function fp_obte_user(p_login in varchar2) return varchar2 is
  
    v_user_desc varchar2(1000);
  begin
    select u.user_desc
      into v_user_desc
      from segu_user u
     where u.user_login = p_login
    --and nvl(u.user_empl_codi, 1) = nvl(v('ai_empr_codi'), 1)
    ;
    return v_user_desc;
  exception
    when others then
      return null;
  end fp_obte_user;

  function fp_buscar_grup_alte(i_filtro in varchar2, i_empresa in number)
    return varchar2 is
    v_return varchar2(100);
  begin
    select cp.grop_codi_alte
      into v_return
      from come_oper_stoc_grup cp
     where cp.grop_empr_codi = i_empresa
       and cp.grop_codi_alte = i_filtro;
    return v_return;
  exception
    when no_data_found then
      return null;
    when invalid_number then
      return null;
    when others then
      return null;
  end fp_buscar_grup_alte;

  function fp_buscar_grup_desc(i_filtro in varchar2, i_empresa in number)
    return varchar2 is
    v_return varchar2(100);
  begin
    select cp.grop_codi_alte
      into v_return
      from come_oper_stoc_grup cp
     where cp.grop_empr_codi = i_empresa
       and upper(cp.grop_desc) like UPPER(i_filtro);
    return v_return;
  exception
    when no_data_found then
      return null;
    when others then
      return null;
  end fp_buscar_grup_desc;

  function fp_get_grupo(i_filtro in varchar2, i_empresa in number)
    return varchar2 is
    v_return varchar2(10) := null;
  begin
  
    --buscar familia por codigo de alternativo
  
    v_return := fp_buscar_grup_alte(i_filtro, i_empresa);
    if v_return is not null then
      raise e_retornar;
    end if;
  
    v_return := fp_buscar_grup_desc(i_filtro, i_empresa);
    if v_return is not null then
      raise e_retornar;
    end if;
  
    return null;
  EXCEPTION
    WHEN E_RETORNAR THEN
      RETURN V_RETURN;
  end;

end I010032;
