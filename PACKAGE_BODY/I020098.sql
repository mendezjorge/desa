
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020098" is


type r_parameter is record(
   
  p_codi_base number :=      pack_repl.fa_devu_codi_base
  
 );
  
  parameter r_parameter;
  
  type r_bcab is record(
    anul_sucu_codi  varchar2(100) ,
    anul_timo_codi  varchar2(100) ,
    anul_nume       varchar2(100) , 
    anul_nume_timb  varchar2(100) , 
    anul_clpr_codi  varchar2(100) , 
    anul_fech_movi  varchar2(100) ,
    timo_emit_reci  varchar2(100) , 
    timo_tico_codi  varchar2(100) , 
    anul_oper_codi  varchar2(100) , 
    anul_obse       varchar2(100) , 
    anul_empr_codi  varchar2(100) , 
    anul_base       varchar2(100) , 
    anul_fech_anul  varchar2(100) , 
    anul_user       varchar2(100) , 
    anul_codi       varchar2(100) ,
    opcion          varchar2(100) ,
    anul_nomb_term  varchar2(100)
    );
   bcab r_bcab; 
  
procedure pp_actu_salt_reci (p_oper in varchar2) is
  cursor c_auto is
    select s.resa_codi
      from come_reci_salt_auto s
     where s.resa_nume_comp = bcab.anul_nume
       and s.resa_esta = 'A'
     order by s.resa_codi;
  
  cursor c_anul is
    select s.resa_codi
      from come_reci_salt_auto s
     where s.resa_nume_comp = bcab.anul_nume
       and s.resa_esta = 'N'
     order by s.resa_codi;
  
begin
  if lower(p_oper) = 'i' then
    if bcab.timo_tico_codi = 5 then
      for k in c_auto loop
        update come_reci_salt_auto s
           set s.resa_esta = 'N'
         where s.resa_codi = k.resa_codi;
      end loop;
    end if;
  elsif lower(p_oper) = 'd' then
    if bcab.timo_tico_codi = 5 then
      for k in c_anul loop
        update come_reci_salt_auto s
           set s.resa_esta = 'A'
         where s.resa_codi = k.resa_codi;
      end loop;
    end if;
  end if;
  
end pp_actu_salt_reci;

procedure pp_variables is 
  begin
    --raise_application_Error(-20001, v('P19_ANUL_CODI'));
   bcab.anul_codi       := v('P19_ANUL_CODI');
 if  bcab.anul_codi  is null then
     bcab.anul_codi       := fa_sec_come_movi_anul;
     bcab.opcion    := 'I';
  else
     bcab.anul_codi       := v('P19_ANUL_CODI');
     bcab.opcion    := 'E';
  end if;  
  
  bcab.anul_sucu_codi := v('P19_ANUL_SUCU_CODI');
  bcab.anul_timo_codi := v('P19_ANUL_TIMO_CODI');
  bcab.anul_nume      := v('P19_ANUL_NUME');
  bcab.anul_nume_timb := v('P19_ANUL_NUME_TIMB');
  bcab.anul_clpr_codi := v('P19_ANUL_CLPR_CODI');
  bcab.anul_fech_movi := v('P19_ANUL_FECH_MOVI');
  bcab.timo_emit_reci := v('P19_TIMO_EMIT_RECI');
  bcab.timo_tico_codi := v('P19_TIMO_TICO_CODI');
  bcab.anul_oper_codi := v('P19_ANUL_OPER_CODI');
  bcab.anul_obse      := v('P19_ANUL_OBSE');
  bcab.anul_empr_codi := v('AI_EMPR_CODI');  
  bcab.anul_base      := parameter.p_codi_base;
 
  bcab.anul_fech_anul	:= sysdate;
  bcab.anul_user			:= gen_user;
  bcab.anul_nomb_term := null;
  --      raise_application_error(-20001,v('AI_EMPR_CODI'));
end pp_variables;

procedure pp_actualizar_registro is
begin
  
pp_variables;
/*IF bcab.anul_nume_timb IS NULL THEN
  IF bcab.anul_timo_codi IN (1,2,3,4,5,6,7,8, 9, 15,11,17,19,20,21,22) THEN
     raise_application_error(-20001,'Debe ingresar el n?mero de timbrado.!');
  END IF;
END IF;*/
   pp_actu_salt_reci('i');
  if bcab.opcion = 'I' then
      insert into come_movi_anul
        (anul_codi,
         anul_clpr_codi,
         anul_oper_codi,
         anul_timo_codi,
         anul_nume,
         anul_fech_movi,
         anul_fech_anul,
         anul_user,
         anul_obse,
         anul_empr_codi,
         anul_base,
         anul_sucu_codi,
         anul_nomb_term,
         anul_nume_timb)
      values
        (bcab.anul_codi,
         bcab.anul_clpr_codi,
         bcab.anul_oper_codi,
         bcab.anul_timo_codi,
         bcab.anul_nume,
         bcab.anul_fech_movi,
         bcab.anul_fech_anul,
         bcab.anul_user,
         bcab.anul_obse,
         bcab.anul_empr_codi,
         bcab.anul_base,
         bcab.anul_sucu_codi,
         bcab.anul_nomb_term,
         bcab.anul_nume_timb);

  else

    update come_movi_anul
       set anul_codi      = bcab.anul_codi,
           anul_clpr_codi = bcab.anul_clpr_codi,
           anul_oper_codi = bcab.anul_oper_codi,
           anul_timo_codi = bcab.anul_timo_codi,
           anul_nume      = bcab.anul_nume,
           anul_fech_movi = bcab.anul_fech_movi,
           anul_obse      = bcab.anul_obse,
           anul_sucu_codi = bcab.anul_sucu_codi,
           anul_nomb_term = bcab.anul_nomb_term,
           anul_nume_timb = bcab.anul_nume_timb
     where anul_codi = bcab.anul_codi;

  end if;



end pp_actualizar_registro;

procedure pp_validar_borrado is
v_count number(6);
begin
  /*select count(*)
  into v_count
  from come_prod
  where prod_marc_codi =  :babmc.marc_codi;
  
  if v_count > 0 then 
  	 pl_mostrar_error('Existen'||'  '||v_count||' '|| 'productos que tienen asignados esta marca. primero debes borrarlos o asignarlos a otra');
  end if;*/
  null;
   
  
end pp_validar_borrado;



procedure pp_borrar_registro is
  -- '?realmente dese borrar el registro?';
begin
   pp_variables;
  	pp_validar_borrado;

  if bcab.anul_codi is null then
   raise_application_Error(-20001, 'Debe elegir un registro para eliminar');
  
  else
     
   pp_actu_salt_reci('d');
  
  update come_movi_anul 
    set anul_base = parameter.p_codi_base
  where anul_codi = bcab.anul_codi;

  delete come_movi_anul
   where anul_codi =  bcab.anul_codi;
--raise_application_Error(-20001, bcab.anul_codi);
  end if;
  
end pp_borrar_registro;


procedure pp_muestra_tipo_movi (i_anul_timo_codi in number,
                                o_timo_emit_reci out varchar2, 
                                o_anul_oper_codi out varchar2, 
                                o_timo_tico_codi out varchar2,
                                o_clie_prov      out varchar2) is
begin
  select  timo_emit_reci      , timo_codi_oper      , timo_tico_codi
         --nvl(timo_calc_iva, 'S'), timo_dbcr       , timo_indi_adel           , timo_indi_ncr
    into o_timo_emit_reci, o_anul_oper_codi, o_timo_tico_codi
         --:bcab.s_timo_calc_iva  ,  :bcab.movi_dbcr, :bcab.movi_timo_indi_adel, :bcab.movi_timo_indi_ncr
    from come_tipo_movi
   where timo_codi = i_anul_timo_codi;            
  
  if o_timo_emit_reci = 'E' then
    o_clie_prov := 'C';
  else
    o_clie_prov := 'P';
  end if; 


/*
if :bcab.timo_emit_reci <> :parameter.p_emit_reci then
  :bcab.timo_desc   := null;
  --:bcab.movi_afec_sald   := null; 
  :bcab.timo_emit_reci   := null;
   pl_me('Tipo de Movimiento no valido para esta operacion');
end if;

if :bcab.anul_oper_codi <> :parameter.p_codi_oper then
   pl_me('Tipo de Movimiento no valido para esta operacion');
end if;  
  */                 
             

Exception
   when no_data_found then
     raise_application_error(-20001, 'Tipo de Movimiento inexistente');
	  When too_many_rows then
     raise_application_error(-20001, 'Tipo de Movimiento duplicado') ;
End pp_muestra_tipo_movi;

procedure pp_validar_nro (i_anul_nume      in number,
                          i_anul_timo_codi in number,
                          o_existe         out number) is
v_count number;
salir exception;
  
begin                                  
	
	
    select count(*)
    into v_count
    from come_movi
    where  movi_nume = i_anul_nume    
    and movi_timo_codi = i_anul_timo_codi;      
    o_existe := v_count;
   
  --  raise_application_error(-20001,v_count||'---'||i_anul_nume||'--'||i_anul_timo_codi);
   /* if v_count > 0 then  
       raise_application_error(-20001,'Ya existe un comprobante vigente en el sistema con este n?mero, favor verifique!!');
    end if;    
    */


/*exception
when others then
     raise_application_error(-20001,'Reingrese el nro de comprobante'); 
  */
end pp_validar_nro;

procedure pp_ejecutar_consulta (I_anul_nume       in varchar2,
                                I_anul_nume_timb  in varchar2,
                                I_anul_timo_codi  in varchar2,
                                i_anul_sucu_codi  in varchar2,
                                o_anul_codi       out varchar2) is
v_codi number;
begin   
      	  	    
   select max(anul_codi)
   into v_codi
   from come_movi_anul
   where anul_nume = I_anul_nume
   and  ((nvl(anul_nume_timb,'0') = nvl(I_anul_nume_timb, '0') and I_anul_timo_codi in (1,2,3,4,5,6,7,8, 9, 15,11,17,19,20,21,22)) or 
   (anul_nume_timb is null and i_anul_timo_codi not in (1,2,3,4,5,6,7,8, 9, 15,11,17,19,20,21,22)))
   and   nvl(anul_empr_codi, 1) = v('AI_EMPR_CODI') -- i_anul_empr_codi
   and   anul_sucu_codi         = i_anul_sucu_codi
   and   anul_timo_codi 			  = i_anul_timo_codi;
	
   
  
   o_anul_codi :=to_char(v_codi);

Exception
  When no_data_found then
   null;
end pp_ejecutar_consulta;

end I020098;
