
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020328" is

  /********************** funciones reutilizadas **************************/
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010,
                            dbms_utility.format_error_backtrace || ' ' ||
                            v_mensaje);
  end pl_me;

  procedure pp_mostrar_come_depo_sucu_qry(p_depo_codi      in number,
                                          p_depo_codi_alte out varchar2,
                                          p_depo_desc      out varchar2,
                                          p_sucu_codi_alte out varchar2,
                                          p_sucu_desc      out varchar2,
                                          p_sucu_codi      out number) is
  begin
    select d.depo_desc,
           d.depo_codi_alte,
           s.sucu_codi_alte,
           s.sucu_desc,
           s.sucu_codi
      into p_depo_desc,
           p_depo_codi_alte,
           p_sucu_codi_alte,
           p_sucu_desc,
           p_sucu_codi
      from come_depo d, come_sucu s
     where d.depo_sucu_codi = s.sucu_codi
       and d.depo_codi = p_depo_codi;
  
  exception
    when no_data_found then
      p_depo_desc      := null;
      p_depo_codi_alte := null;
      p_sucu_codi_alte := null;
      p_sucu_desc      := null;
      p_sucu_codi      := null;
      pl_me('Deposito inexistente');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_mostrar_come_prod_qry(p_prod_codi      in number,
                                     p_prod_codi_alfa out varchar2,
                                     p_prod_desc      out varchar2) is
  begin
    select p.prod_desc, p.prod_codi_alfa
      into p_prod_desc, p_prod_codi_alfa
      from come_prod p
     where prod_codi = p_prod_codi;
  
  exception
    when no_data_found then
      p_prod_desc      := null;
      p_prod_codi_alfa := null;
      pl_me('Producto inexistente!');
    when too_many_rows then
      pl_me('Codigo de producto duplicado!');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_mostrar_come_unid_medi(p_codi      in number,
                                      p_prod_codi in number,
                                      p_desc_abre out varchar2,
                                      p_fact_conv out number) is
  begin
    begin
      select ltrim(rtrim(medi_desc_abre))
        into p_desc_abre
        from come_unid_medi m
       where m.medi_codi = p_codi;
    exception
      when no_data_found then
        p_desc_abre := null;
        p_fact_conv := 1;
        pl_me('Unidad de medida inexistente');
    end;
  
    begin
      select nvl(d.coba_fact_conv, 1)
        into p_fact_conv
        from come_prod_coba_deta d
       where d.coba_medi_codi = p_codi
         and d.coba_prod_codi = p_prod_codi;
    exception
      when no_data_found then
        p_fact_conv := 1;
        pl_me('Unidad de medida inexistente para el producto seleccionado!!!');
      when too_many_rows then
        p_fact_conv := 1;
        pl_me('Existe mas de un codigo de barra con la misma unidad de medida!.');
    end;
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_borrar_canc(p_canc_codi in number) is
  
  begin
  
    delete come_soli_tras_depo_deta_canc where canc_codi = p_canc_codi;
  
  end;

end I020328;
