
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020335" is

 
 procedure pp_valida(p_dein_clpr_codi in number,
                     p_dein_porc in number) is
 begin
  if p_dein_clpr_codi is null then
    raise_application_error(-20001,'Debe ingresar el c?digo del cliente.'); 
  end if;  
    
  if p_dein_porc is null then
     raise_application_error(-20001,'Debe ingresar el porcentaje a autorizar.');
  end if;

  if p_dein_porc <= 0 then
     raise_application_error(-20001,'El porcentaje a autorizar debe ser mayor a cero.');
  end if;
 end pp_valida;
 
 
 procedure pp_validar_cred_pend(p_dein_clpr_codi in number) is

v_count      number;
v_codi       number;
v_porc       number;
v_fech       date;

begin
  select count(*)
  into v_count
  from come_auto_desc_inte
  where dein_clpr_codi =  p_dein_clpr_codi
    and dein_esta = 'P';
  
  if v_count > 0 then 
     begin
        select dein_codi , dein_porc, nvl(dein_fech_modi, dein_fech_regi)
        into v_codi, v_porc, v_fech
        from come_auto_desc_inte
        where dein_clpr_codi = p_dein_clpr_codi
          and dein_esta = 'P';
        
         raise_application_error(-20001,'El cliente ya posee una autorizacion activa de fecha '||to_char(v_fech,'dd-mm-yyyy')||' del '||v_porc||'%'||
                ' con Nro. de Autorizacion '||v_codi);
     end;
  end if;

end pp_validar_cred_pend;


procedure pp_actualizar_registro(p_dein_codi in number,
                                 p_dein_clpr_codi in number,
                                 p_dein_obse in varchar2,
                                 p_dein_porc in number,
                                 p_dein_empr_codi in number,
                                 p_dein_esta in varchar2) is


begin
  pp_valida(p_dein_clpr_codi ,p_dein_porc );

  
  update come_auto_desc_inte set dein_clpr_codi  = p_dein_clpr_codi,
                                 dein_obse       = p_dein_obse,
                                 dein_porc       = p_dein_porc,
                                 dein_user_modi  = gen_user,
                                 dein_fech_modi  = sysdate
                           where dein_codi       = p_dein_codi;
                          
  if sql%rowcount = 0 then
      pp_validar_cred_pend(p_dein_clpr_codi); 
    insert into come_auto_desc_inte
  (dein_codi,
   dein_clpr_codi,
   dein_obse,
   dein_porc,
   dein_esta,
   dein_user_regi,
   dein_fech_regi,
   dein_empr_codi)
values
  (p_dein_codi,
   p_dein_clpr_codi,
   p_dein_obse,
   p_dein_porc,
   p_dein_esta,
   gen_user,
   sysdate,
   p_dein_empr_codi);
    end if;
end pp_actualizar_registro;

procedure pp_validar_borrado(P_dein_codi IN NUMBER) is

v_count      number;

begin
  select count(*)
  into v_count
  from come_auto_desc_inte
  where dein_codi = P_dein_codi
    and dein_esta = 'C';
  
  if v_count > 0 then 
      raise_application_error(-20001,'La autorizaci?n de este descuento ya fue confirmado.');
  else
     begin
        select count(*)
        into v_count
        from come_auto_desc_inte
        where dein_codi = P_dein_codi;
        
        if v_count = 0 then 
          raise_application_error(-20001,'El registro ya fue eliminado o no existe.');
        end if;
        
      Exception
        when no_data_found then
          raise_application_error(-20001,'El registro ya fue eliminado o no existe.');
      end;
  end if;

end pp_validar_borrado;

procedure pp_eliminar_registro(p_dein_codi in number)
  is
  begin
    pp_validar_borrado(P_dein_codi);
    
    
    delete come_auto_desc_inte
   where dein_codi = p_dein_codi;

    end pp_eliminar_registro;



end I020335;
