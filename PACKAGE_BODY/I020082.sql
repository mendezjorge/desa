
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020082" is

  procedure pp_validar_nume_ot(p_ortr_nume in number,
                               p_ortr_codi out number,
                               p_ortr_sucu in number,
                               p_ortr_empr in number) is
    v_esta      char(1);
    v_sucu_codi number;
  begin
  
    select ortr_codi, ortr_esta, ortr_sucu_codi
      into p_ortr_codi, v_esta, v_sucu_codi
      from come_orde_trab
     where ortr_nume = p_ortr_nume
       and ortr_sucu_codi = p_ortr_sucu
       and ortr_empr_codi = p_ortr_empr;
  
    if v_esta not in (1, 2) then
      raise_application_error(-20001,
                              'Solo se pueden autorizar Pedidos de O.S. Pendientes y Autorizadas');
    end if;
  
    if v_sucu_codi <> p_ortr_sucu then
      raise_application_error(-20001, 'La OS no pertenece al M?dulo');
    end if;
  
  Exception
    When no_data_found then
      raise_application_error(-20001,
                              'No existe un Nro de Servicio para este M?dulo');
    When too_many_rows then
      raise_application_error(-20001, 'Nro de Servicio Duplicado ');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_validar_nume_ot;

  procedure pp_validar_pedi(p_pedi_nume      in number,
                            p_accion         in varchar2,
                            p_pedi_esta      out varchar2,
                            p_pedi_codi      out number,
                            p_ortr_codi      out number,
                            p_pedi_esta_orig out varchar2) is
  begin
    if p_pedi_nume is null then
      raise_application_error(-20001, 'Debe ingresar el Numero de Pedido');
    else
      pp_validar_pedido(p_pedi_nume,
                        p_pedi_codi,
                        p_ortr_codi,
                        p_accion,
                        p_pedi_esta);
      p_pedi_esta_orig := p_pedi_esta;
    
      if p_pedi_esta = 'P' then
        p_pedi_esta := 'A';
      else
        p_pedi_Esta := 'P';
      end if;
    
    end if;
  end pp_validar_pedi;

  procedure pp_validar_pedido(p_pedi_nume      in number,
                              p_pedi_codi      out number,
                              p_pedi_ortr_codi in number,
                              p_pedi_esta      in varchar2,
                              p_pedi_esta_orig out varchar2) is
    v_pedi_ortr_codi number;
    v_pedi_tipo      varchar2(1);
    v_pedi_esta      varchar2(1);
  
  begin
  
    select pedi_codi, pedi_ortr_codi, pedi_esta, pedi_tipo, pedi_esta s
      into p_pedi_codi,
           v_pedi_ortr_codi,
           v_pedi_esta,
           v_pedi_tipo,
           p_pedi_esta_orig
      from come_ortr_pedi_serv, come_orde_trab
     where pedi_ortr_codi = ortr_codi
       and pedi_nume = p_pedi_nume;
  
    if v_pedi_esta <> p_pedi_esta then
      if p_pedi_esta = 'P' then
        raise_application_error(-20001,
                                'El pedido seleccionado ya se encuentra Autorizado');
      elsif p_pedi_esta = 'A' then
        raise_application_error(-20001,
                                'El pedido seleccionado ya se encuentra Pendiente');
      end if;
    end if;
  
    if v_pedi_ortr_codi <> p_pedi_ortr_codi then
      raise_application_error(-20001,
                              'El Pedido no pertenece a la Orden de Servicio seleccionada');
    end if;
  
    if v_pedi_tipo <> 'M' then
      raise_application_error(-20001,
                              'El pedido no necesita autorizacion, porque se carg? con la Orden de Servicio');
    end if;
  
  Exception
    When no_data_found then
      raise_application_error(-20001, 'Pedido Inexistente');
    When too_many_rows then
      raise_application_error(-20001, 'Nro de Pedido Duplicado');
  end pp_validar_pedido;

  procedure pp_cargar_bloq_deta(p_pedi_codi in number) is
  
    cursor c_pedi is
      select pedi_nume,
             pedi_codi,
             deta_nume_item,
             prod_codi,
             prod_codi_alfa,
             prod_desc,
             deta_cant
      
        from come_ortr_pedi_serv, come_ortr_pedi_serv_deta, come_prod
       where pedi_codi = deta_pedi_codi
         and deta_prod_codi = prod_codi
         and pedi_tipo = 'M' --tipo de pedido Manual.....
         and pedi_codi = p_pedi_codi
       order by 1;
  
    v_indi_entro varchar2(1) := 'N';
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
  
    for x in c_pedi loop
    
      apex_collection.add_member(p_collection_name => 'BDETALLE',
                                 p_c001            => x.prod_codi_alfa, ---ind_marcado                            
                                 p_c002            => x.prod_desc,
                                 p_c003            => x.deta_cant);
    
      v_indi_entro := 'S';
    end loop;
  
    if v_indi_entro = 'N' then
    
      raise_application_error(-20001,
                              'No existen datos para el criterio de selecci?n!!');
    end if;
  
  end pp_cargar_bloq_deta;
  
  procedure pp_actu_pedi (p_pedi_codi in number, 
                          p_pedi_esta in varchar2) is
begin
 	 update come_ortr_pedi_serv set pedi_esta  = p_pedi_esta, 
  		 	                          pedi_base  = pack_repl.fa_devu_codi_base
   where pedi_codi = p_pedi_codi;

end pp_actu_pedi;
  


  procedure pp_actualizar_registro(p_pedi_codi in number,
                                   p_pedi_esta in varchar2,
                                   p_pedi_esta_orig in varchar2
                                   ) is
  begin
  if p_pedi_codi is not null then  	
  	if p_pedi_esta <> p_pedi_esta_orig then
       pp_actu_pedi(p_pedi_codi, p_pedi_esta); 
     
  	else
  		  raise_application_error(-20001,'No hubo ning?n cambio.. ');
    end if;   
  else
     raise_application_error(-20001,'Primero debe seleccionar un Pedido');
  end if;
  
  
  

end pp_actualizar_registro;


end I020082;
