
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020121" is
procedure pp_cargar_parametros (p_empresa              in number,
                                p_sucursal             in number,
                                p_codi_ejer_fisc_actu  out varchar2,
                                p_codi_base            out varchar2,
                                p_codi_mone_mmee       out varchar2,
                                p_codi_mone_mmnn       out varchar2,
                                p_cant_deci_mmnn       out varchar2,
                                p_cant_deci_mmee       out varchar2,
                                p_indi_cuad_resu_cent_cost out varchar2,
                                p_asie_ejer_codi           in out varchar2,
                                p_ejer_desc                out varchar2,
                                p_ejer_fech_inic           out varchar2,
                                p_ejer_fech_fini            out varchar2) is
begin
 
  p_codi_ejer_fisc_actu  := to_number(general_skn.fl_busca_parametro('p_codi_ejer_fisc_actu'));
  p_codi_base            := pack_repl.fa_devu_codi_base; 
  p_codi_mone_mmee       := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmee'));
  p_codi_mone_mmnn       := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn'));
  p_cant_deci_mmnn       := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn'));
  p_cant_deci_mmee       := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmee'));
  p_indi_cuad_resu_cent_cost := general_skn.fl_busca_parametro ('p_indi_cuad_resu_cent_cost');
    
 if p_asie_ejer_codi is not null  then
   
  p_asie_ejer_codi := p_asie_ejer_codi;
  else
    
  p_asie_ejer_codi := p_codi_ejer_fisc_actu;
  
  end if;
  pp_mostrar_ejercicio (p_asie_ejer_codi, p_ejer_desc, p_ejer_fech_inic,p_ejer_fech_fini );
  
  
  APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETALLE');
end pp_cargar_parametros;

procedure pp_mostrar_ejercicio (p_ejer_codi      in number, 
                                p_ejer_desc      out varchar2, 
                                p_ejer_fech_inic out date, 
                                p_ejer_fech_fini out date)  is
begin
  
  
  select ejer_desc   , ejer_fech_inic    , ejer_fech_fina
  into  p_ejer_desc  , p_ejer_fech_inic  , p_ejer_fech_fini
  from come_ejer_fisc
  where ejer_codi = p_ejer_codi;
  
  
Exception
	  When no_data_found then
	   raise_application_error(-20001, 'Ejercicio Fiscal Inexistente!');  
end pp_mostrar_ejercicio;



procedure pp_carga_asientos(p_asie_nume        in number, 
                            p_asie_empr_codi   in number, 
                            p_asie_ejer_codi   in number, 
                            p_asie_codi        in number,
                            p_asie_nro         out number,
                            p_asie_mone_codi   out number,
                            p_asie_fech_emis   out date,
                            p_asie_obse        out varchar2,
                            p_asie_tasa_mone   out varchar2,
                            p_asie_tasa_mmee   out varchar2,
                           -- p_asie_codi,
                            p_asie_indi_manu   out varchar2,
                            p_asie_debe_mone   out varchar2,
                            p_asie_habe_mone   out varchar2/*,
                            p_asie_user_regi   out varchar2,
                            p_asie_user_modi   out varchar2,
                            p_asie_fech_regi   out varchar2,
                            p_asie_fech_modi   out varchar2*/) is


       
cursor c_come_asie_deta (p_asie_codi in number) is
select d.deta_nume_item,
       d.deta_asie_codi,
       d.deta_cuco_codi,
       d.deta_ceco_codi,
       c.cuco_nume,
       c.cuco_desc,
       d.deta_indi_dbcr , 
       d.deta_impo_mone
from  come_asie_deta d,
      come_cuen_cont c
where d.deta_cuco_codi = c.cuco_codi
and   d.deta_asie_codi = p_asie_codi
order by d.deta_nume_item;



v_asie_codi number;
v_asie_indi_manu varchar2(1);

v_desc varchar2(600);
v_codi varchar2(60);
v_tipo varchar2(60);
v_asie_user_regi varchar2(60);
v_asie_user_modi varchar2(60);
v_asie_fech_regi date;
v_asie_fech_modi date;
begin 
  
      -- raise_application_error(-20001, p_asie_ejer_codi||'--'||p_asie_empr_codi||'--'||p_asie_nume);
      begin

        select asie_codi, nvl(asie_indi_manu, 'A')
          into v_asie_codi, v_asie_indi_manu
          from come_asie, come_ejer_fisc
         where asie_fech_emis between ejer_fech_inic and ejer_fech_fina
           and asie_nume = p_asie_nume
           and asie_empr_codi = p_asie_empr_codi
           and nvl(asie_ejer_codi, ejer_Codi) = p_asie_ejer_codi;

      Exception
        When no_data_found then
          raise_application_error(-20001, 'Nro de Asiento inexistente!!');
       /* when too_many_rows then
          v_asie_codi      := null;
          v_asie_indi_manu := null;*/
        
      end;

   if nvl(v_asie_indi_manu, 'M') <> 'M' then
    null;-- raise_application_error(-20001, 'El asiento no fue cargado Manualmente!!, no se podr? modificar');
   end if;       
   

 
   
select a.asie_nume,
       a.asie_mone_codi,
       a.asie_fech_emis,
       a.asie_obse,
       a.asie_tasa_mone,
       a.asie_tasa_mmee,
      -- a.asie_codi,
       a.asie_indi_manu,
       a.asie_debe_mone,
       a.asie_habe_mone,
       a.asie_user_regi,
       a.asie_user_modi,
       a.asie_fech_regi,
       a.asie_fech_modi
   into p_asie_nro,
        p_asie_mone_codi,
        p_asie_fech_emis,
        p_asie_obse,
        p_asie_tasa_mone,
        p_asie_tasa_mmee,
        --p_asie_codi,
        p_asie_indi_manu,
        p_asie_debe_mone,
        p_asie_habe_mone,
        v_asie_user_regi,
        v_asie_user_modi,
        v_asie_fech_regi,
        v_asie_fech_modi
  from come_asie a, come_mone m
 where a.asie_mone_codi = m.mone_codi(+)
   and a.asie_codi = p_asie_codi;
 
 setitem('P5_ASIE_USER_REGI', v_asie_user_regi);
 setitem('P5_ASIE_FECH_REGI', v_asie_fech_regi);
 setitem('P5_ASIE_USER_MODI', v_asie_user_modi);
  setitem('P5_ASIE_FECH_MODI', v_asie_fech_modi);

 for y in c_come_asie_deta (v_asie_codi)loop   
      
 

  I020121.pp_muestra_come_cuen_cont(p_nume => y.cuco_nume,
                                    p_desc => v_desc,
                                    p_codi => v_codi,
                                    p_tipo => v_tipo,
                                    p_empr => 1);


    apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => y.deta_nume_item,
                                 p_c002            => v_codi,--y.deta_cuco_codi,
                                 p_c003            => y.deta_ceco_codi,
                                 p_c004            => y.cuco_nume,-------
                                 p_c005            => y.deta_indi_dbcr,
                                 p_c006            => y.deta_impo_mone,
                                 p_c007            => v_desc,
                                 p_c008            => v_tipo --tipo cuenta
                                 );
                                 

  
 
 
   
 end loop;   

end pp_carga_asientos;  


procedure pp_muestra_come_cuen_cont(p_nume in number,
                                    p_desc out varchar2,
                                    p_codi out number,
                                    p_tipo out varchar2,
                                    p_empr in number) is
  v_indi_impu varchar2(1);
  v_empr_codi number;
begin
-- raise_application_error (-20001,'holis');
  select cuco_desc, cuco_codi, cuco_indi_impu, cuco_empr_codi, cuco_tipo_cuen
  into   p_desc, p_codi, v_indi_impu, v_empr_codi, p_tipo
  from   come_cuen_cont
  where  cuco_nume = p_nume;
  
  if nvl(v_indi_impu , 'N') <> 'S' then
    raise_application_error (-20001, 'Solo se pueden ingresar cuentas contables imputables !!!');
  end if;
  
  if v_empr_codi <> p_empr then
    raise_application_error (-20001, 'La cuenta contable no pertenece a la empresa seleccionada !!!');
  end if;
  
  
Exception
  when no_data_found then
      raise_application_error(-20001, 'Cuenta Contable inexistente!');

  when others then
    raise_application_error(-20001, 'Error Cuenta Contable!');
end pp_muestra_come_cuen_cont;

procedure pp_genera_asie_nume (p_empr           in number,
                               p_asie_ejer_codi in number,
                               p_nume           out number) is
begin
  select nvl(max(asie_nume),0) + 1
	  into p_nume
	  from come_asie, come_ejer_fisc
    where asie_empr_codi = p_empr
   and asie_Fech_emis between   ejer_fech_inic and ejer_fech_fina
    and nvl(asie_ejer_codi, ejer_Codi) = p_asie_ejer_codi ;

end pp_genera_asie_nume;


procedure pp_validar_fecha (p_fech_emis        in out date,
                            p_asie_codi_a_modi in number,
                            p_asie_mone_codi   in number,
                            p_codi_mone_mmee   in number,
                            p_asie_tasa_mmee   out number,
                            p_ejer_fech_inic   in date,
                            p_ejer_fech_fini   in date,
                            p_codi_mone_mmnn   in number) is
begin
if p_fech_emis is null then
   p_fech_emis := trunc(sysdate);
end if;	
	
p_fech_emis := p_fech_emis;


if p_fech_emis not between p_ejer_fech_inic and p_ejer_fech_fini then
  	raise_application_error(-20001, 'La Fecha del asiento debe estar dentro periodo del Ejercicio Fiscal seleccionado '||to_char(p_ejer_fech_inic, 'dd-mm-yyyy') 
  	                 ||' y '||to_char(p_ejer_fech_fini, 'dd-mm-yyyy'));
end if;	
  

if p_asie_codi_a_modi is null then
	if p_asie_mone_codi <> 1 then
  ---	pp_busca_tasa_mmee (p_codi_mone_mmee, p_asie_tasa_mmee);
    
      I020121.pp_busca_tasa_mmee(p_mone_codi      => p_codi_mone_mmee,
                                 p_mone_coti      => p_asie_tasa_mmee,
                                 p_codi_mone_mmnn => p_codi_mone_mmnn,
                                 p_fech_emis      => p_fech_emis);
	else
		p_asie_tasa_mmee := 1;
	end if;
end if;          

end pp_validar_fecha;


procedure pp_busca_tasa_mmee (p_mone_codi               in number, 
                              p_mone_coti               out number,
                              p_codi_mone_mmnn          in number,
                              p_fech_emis               in date)is
begin
                       
  if p_codi_mone_mmnn = p_mone_codi then
     p_mone_coti := 1;
  else
    select coti_tasa
    into p_mone_coti
    from come_coti
    where coti_mone = p_mone_codi
    and coti_tica_codi = 2
    and coti_fech   = p_fech_emis;
  end if;   

  Exception
      When no_data_found then
        raise_application_error(-20001, 'Cotizaciion Inexistente para la moneda extranjera  ');
       when others then
         raise_application_error(-20001, 'Error al buscar cotizacion');
  
end pp_busca_tasa_mmee;

procedure pp_buscar_moneda (p_asie_mone_codi in out number,
                            p_codi_mone_mmnn in number,
                            p_mone_cant_deci out number,
                            p_mone_coti      out number,
                            p_asie_fech_emis in date)is
  
v_mone_desc varchar2(60);
v_mone_desc_abre varchar2(60);
begin
  if p_asie_mone_codi is  null then
	  p_asie_mone_codi := p_codi_mone_mmnn;
end if;

   general_skn.pl_muestra_come_mone (p_asie_mone_codi, v_mone_desc, v_mone_desc_abre, p_mone_cant_deci);


     begin        
        if p_codi_mone_mmnn = p_asie_mone_codi then
           p_mone_coti := 1;
        else
          select coti_tasa
          into p_mone_coti
          from come_coti
          where coti_mone = p_asie_mone_codi
          and coti_tica_codi = 2
          and coti_fech   = p_asie_fech_emis;
        end if;   
--raise_application_error (-20001,p_asie_fech_emis||'--'||p_asie_mone_codi||'--'||p_mone_coti);
        Exception
            When no_data_found then  
              raise_application_error (-20001, 'Cotizaciion Inexistente para la fecha del documento');
            when others then
              raise_application_error (-20001, 'Cotizaciion Inexistente para la fecha del documento');
        
      end;
           
end pp_buscar_moneda;

procedure pp_muestra_come_asie_tipo (p_codi in number, 
                                     p_desc out varchar2) is

begin

select asti_desc
into   p_desc
from   come_asie_tipo
where  asti_codi = p_codi;

Exception
  when no_data_found then
      raise_application_error(-20001, 'Asiento Tipo inexistente!');
  when others then
    raise_application_error(-20001, 'Error al buscar Asiento Tipo!');
end pp_muestra_come_asie_tipo;

procedure pp_actualizar_registro(p_asie_codi      in number,
                                 p_asie_nume      in number,
                                 p_asie_ejer_codi in number,
                                 p_fech_emis      in varchar2,
                                 p_ejer_fech_inic in varchar2,
                                 p_ejer_fech_fini in varchar2, 
                                 p_asie_mone_codi    in number,
                                 p_asie_fech_emis    in varchar2,
                                 p_asie_fech_grab    in varchar2,
                                 p_asie_user         in varchar2,
                                 p_asie_obse         in varchar2,
                                 p_asie_nume_impr    in number,
                                 p_asie_tasa_mone    in number,
                                 p_asie_tasa_mmee    in number,
                                 p_asie_empr_codi    in number,
                                 p_asie_sucu_codi    in number,
                                 p_p_regi_modi       in varchar2,
                                 p_asie_user_regi    in varchar2,
                                 p_asie_fech_regi    in varchar2,
                                 p_codi_base         in number,
                                 p_cant_deci_mmee    in number,
                                 p_cant_deci_mmnn    in number) is
  
v_count          number;
v_nume           number := 0;
v_asie_nume      number;
v_p_nume_orig    number;
v_p_nume_modi    number;

v_asie_debe_mmee number;
v_asie_habe_mmee number;
v_asie_debe_mmnn number;
v_asie_habe_mmnn number;
v_asie_indi_manu varchar2(20);
v_asie_codi      number;

v_asie_fech_grab date;
v_asie_user      varchar2(60);

v_asie_user_modi varchar2(60);
v_asie_fech_modi date;

v_asie_user_regi varchar2(60);
v_asie_fech_regi date;


v_asie_debe_mone number;
v_asie_habe_mone number;
begin
-- raise_application_error(-20001, 'El nro de asiento esta vacio!');
  if p_asie_nume is null then 
  raise_application_error(-20001, 'El nro de asiento esta vacio!');
  end if;
 if p_fech_emis is null then 
  raise_application_error(-20001, 'La fecha no puede quedar vacia!');
  end if;
	 
  
  
if p_fech_emis not between p_ejer_fech_inic and p_ejer_fech_fini then
  	raise_application_error(-20001, 'La Fecha del asiento debe estar dentro periodo del Ejercicio Fiscal seleccionado '||to_char(p_ejer_fech_inic, 'dd-mm-yyyy') 
  	                 ||' y '||to_char(p_ejer_fech_fini, 'dd-mm-yyyy'));
end if;	


if  p_asie_mone_codi is null then 
  
 raise_application_error(-20001, 'La moneda no puede quedar vacia!');
end if;
  

 select nvl(sum(
           case when c005 = 'D' then
              to_number(c006)
              end),0) debe,
          nvl(sum(case when c005 = 'H' then
             to_number(c006)
              end),0) haber
       into v_asie_debe_mone, v_asie_habe_mone 
      from apex_collections a
     where collection_name = 'DETALLE';
     
     
     if v_asie_debe_mone<> v_asie_habe_mone then
        raise_application_error(-20001, 'Existe una diferencia entre el total Debe y el total Haber !');
     end if;
     
     if nvl(v_asie_debe_mone,0) <= 0 then
         raise_application_error(-20001, 'El importe no puede quedar vacio !');
     
     end if;
  if p_asie_codi is null then

        begin
          v_nume        := p_asie_nume;
          v_p_nume_orig := v_nume;
          v_p_nume_modi := null;
       
              select count(*)
              into v_count
              from come_asie, come_ejer_fisc
              where  asie_fech_emis between ejer_fech_inic and ejer_fech_fina
              and asie_nume = v_nume
              and nvl(asie_ejer_codi, ejer_codi) = p_asie_ejer_codi
              and nvl(p_asie_codi,-1) <> asie_codi ;
              
              if v_count > 0 then
                v_nume := v_nume + 1;
              else
                v_nume := v_nume;
              end if;   
        
          
          v_asie_nume        := v_nume; 
          v_p_nume_modi      := v_asie_nume;
          
          
          
        end;
  end if;		
        
if p_fech_emis not between p_ejer_fech_inic and p_ejer_fech_fini then
  	raise_application_error(-20001, 'La Fecha del asiento debe estar dentro periodo del Ejercicio Fiscal seleccionado '||to_char(p_ejer_fech_inic, 'dd-mm-yyyy') 
  	                 ||' y '||to_char(p_ejer_fech_fini, 'dd-mm-yyyy'));
end if;	

if p_p_regi_modi <>'R' then

-------------si se edita elimina y carga uno nuevo
I020121.pp_dele_asie_orig(p_asie_codi,
                           p_codi_base);
end if;
          
v_asie_codi                       := fa_sec_come_asie;
v_asie_fech_grab                  := sysdate;
v_asie_user                       := gen_user;

v_asie_debe_mmnn                  := round((v_asie_debe_mone*p_asie_tasa_mone),0);
v_asie_habe_mmnn                  := round((v_asie_habe_mone*p_asie_tasa_mone),0);
v_asie_indi_manu                  := 'M'; -- Asiento Manual


  if p_p_regi_modi = 'R' then
    if p_asie_user_regi is null then
      v_asie_user_regi := gen_user;
      v_asie_fech_regi := sysdate;
    else
      
      v_asie_user_regi := p_asie_user_regi;
      v_asie_fech_regi := p_asie_fech_regi;
    end if;
  else
   v_asie_user_regi := p_asie_user_regi;
   v_asie_fech_regi := p_asie_fech_regi; 
    v_asie_user_modi := gen_user;
    v_asie_fech_modi := sysdate;
  end if;


 pp_actualiza_come_asie(v_asie_codi                     ,
                        p_asie_ejer_codi                ,  
                        p_asie_nume                     ,
                        p_asie_mone_codi                ,
                        p_asie_fech_emis                ,
                        v_asie_fech_grab                ,
                        v_asie_user                     ,
                        p_asie_obse                     ,
                        p_asie_nume_impr                ,
                        p_asie_tasa_mone                ,
                        p_asie_tasa_mmee                ,
                        v_asie_debe_mmnn                ,
                        v_asie_debe_mone                ,
                        v_asie_debe_mmee                ,
                        v_asie_habe_mmee                ,
                        v_asie_habe_mone                ,
                        v_asie_habe_mmnn                ,
                        v_asie_indi_manu                ,
                        p_asie_empr_codi                ,
                        p_asie_sucu_codi                ,
                        v_asie_user_regi                ,
                        v_asie_user_modi                ,
                        v_asie_fech_regi                ,
                        v_asie_fech_modi                ,
                        p_codi_base                     );
                        
                        
  I020121.pp_actualiza_come_asie_deta(p_asie_codi      => v_asie_codi,
                                      p_codi_base      => p_codi_base,
                                      p_asie_tasa_mone => p_asie_tasa_mone,
                                      p_cant_deci_mmee => p_cant_deci_mmee,
                                      p_cant_deci_mmnn => p_cant_deci_mmnn,
                                      p_asie_tasa_mmee => p_asie_tasa_mmee);

-- raise_application_error(-20001,p_asie_mone_codi||'--'||p_asie_tasa_mone);
  -- raise_application_error(-20001, 'holis'||p_p_regi_modi);
end pp_actualizar_registro;



procedure pp_actualiza_come_asie(p_asie_codi                       in  number  ,
                                  p_asie_ejer_codi                  in  number  ,  
                                  p_asie_nume                       in  number  ,
                                  p_asie_mone_codi                  in  number  ,
                                  p_asie_fech_emis                  in  date    ,
                                  p_asie_fech_grab                  in  date    ,
                                  p_asie_user                       in  varchar2,
                                  p_asie_obse                       in  varchar2,
                                  p_asie_nume_impr                  in  number  ,
                                  p_asie_tasa_mone                  in  number  ,
                                  p_asie_tasa_mmee                  in  number  ,
                                  p_asie_debe_mmnn                  in  number  ,
                                  p_asie_debe_mone                  in  number  ,
                                  p_asie_debe_mmee                  in  number  ,
                                  p_asie_habe_mmee                  in  number  ,
                                  p_asie_habe_mone                  in  number  ,
                                  p_asie_habe_mmnn                  in  number  ,
                                  p_asie_indi_manu                  in  varchar2,
                                  p_asie_empr_codi                  in  number  ,
                                  p_asie_sucu_codi                  in  number  ,
                                  p_asie_user_regi                  in  varchar2,
                                  p_asie_user_modi                  in  varchar2 ,
                                  p_asie_fech_regi                  in  varchar2,
                                  p_asie_fech_modi                  in  varchar2,
                                  p_codi_base                       in number)is
    
begin

 
  

  insert into come_asie (
  
    asie_codi                         ,
    asie_ejer_codi                    ,  
    asie_nume                         ,
    asie_mone_codi                    ,
    asie_fech_emis                    ,
    asie_fech_grab                    ,
    asie_user                         ,
    asie_obse                         ,
    asie_nume_impr                    ,
    asie_tasa_mone                    ,
    asie_tasa_mmee                    ,
    asie_debe_mmnn                    ,
    asie_debe_mone                    ,
    asie_debe_mmee                    ,
    asie_habe_mmee                    ,
    asie_habe_mone                    ,
    asie_habe_mmnn                    ,
    asie_indi_manu                    ,
    asie_empr_codi                    ,
    asie_sucu_codi                    ,
    asie_user_regi                    ,
    asie_user_modi                    ,
    asie_fech_regi                    ,
    asie_fech_modi                    ,
    asie_base                         ) 
  values (
    p_asie_codi                       ,
    p_asie_ejer_codi                  , 
    p_asie_nume                       ,
    p_asie_mone_codi                  ,
    p_asie_fech_emis                  ,
    p_asie_fech_grab                  ,
    p_asie_user                       ,
    p_asie_obse                       ,
    p_asie_nume_impr                  ,
    p_asie_tasa_mone                  ,
    p_asie_tasa_mmee                  ,
    p_asie_debe_mmnn                  ,
    p_asie_debe_mone                  ,
    p_asie_debe_mmee                  ,
    p_asie_habe_mmee                  ,
    p_asie_habe_mone                  ,
    p_asie_habe_mmnn                  ,
    p_asie_indi_manu                  ,
    p_asie_empr_codi                  ,
    p_asie_sucu_codi                  ,
    p_asie_user_regi                  ,
    p_asie_user_modi                  ,
    p_asie_fech_regi                  ,
    p_asie_fech_modi                  , 
    p_codi_base           );



end;

procedure pp_actualiza_come_asie_deta (p_asie_codi in number,
                                       p_codi_base in number,
                                       p_asie_tasa_mone  in number,
                                       p_cant_deci_mmee  in number,
                                       p_cant_deci_mmnn  in number,
                                       p_asie_tasa_mmee  in number) is


  v_deta_asie_codi          number;
  v_deta_cuco_codi          number;
  v_deta_ceco_codi          number;
  v_deta_indi_dbcr          varchar2 (2);
  v_deta_impo_mone          number;
  v_deta_impo_mmnn          number;
  v_deta_impo_mmee          number;
  v_deta_nume_movi          number;
  v_deta_tasa_mone          number;
  v_deta_tasa_mmee          number;
  v_deta_nume_item          number;



begin

  v_deta_asie_codi := p_asie_codi;
  v_deta_nume_movi          := null;
  v_deta_tasa_mone          := null;
  v_deta_tasa_mmee          := null;
  
  for x in (
           select seq_id numero_item,
                   C001   Nro,
                   c002   deta_cuco_codi,
                   c003   deta_ceco_codi,
                   c004   cuco_nume,
                   decode(c005,'D','Debe','Haber')  ind_desc,
                   to_number(c006)   deta_impo_mone,
                   case when c005 = 'D' then
                      to_number(c006)
                      end impo_debe_mone,
                  case when c005 = 'H' then
                     to_number(c006)
                      end impo_habe_mone  ,
                      c007 descripcion,
                      c008 tipo,
                      c005 deta_indi_dbcr
              from apex_collections a
             where collection_name = 'DETALLE') loop
          
  
   if nvl(x.deta_impo_mone,0) <= 0 then
         raise_application_error(-20001, 'El importe no puede quedar vacio !');
     
     end if;
    
     v_deta_impo_mone          := nvl(x.impo_debe_mone,0) + nvl(x.impo_habe_mone,0);
     v_deta_impo_mmnn          := round((v_deta_impo_mone * p_asie_tasa_mone), p_cant_deci_mmnn);
     v_deta_impo_mmee          := round((v_deta_impo_mmnn / p_asie_tasa_mmee), p_cant_deci_mmee);
 
          insert into come_asie_deta (
        
          deta_asie_codi         ,
          deta_cuco_codi         ,
          deta_indi_dbcr         ,
          deta_ceco_codi         ,
          deta_impo_mone         ,
          deta_impo_mmnn         ,
          deta_impo_mmee         ,
          deta_nume_movi         ,
          deta_tasa_mone         ,
          deta_tasa_mmee         ,
          deta_nume_item         ,  
          deta_base) values (
        
          v_deta_asie_codi         ,
          x.deta_cuco_codi         ,
          x.deta_indi_dbcr         ,
          x.deta_ceco_codi         ,
          v_deta_impo_mone         ,
          v_deta_impo_mmnn         ,
          v_deta_impo_mmee         ,
          v_deta_nume_movi         ,
          v_deta_tasa_mone         ,
          v_deta_tasa_mmee         ,
          x.Nro                      ,
          p_codi_base  ) ;  
  end loop; 
  
   

end pp_actualiza_come_asie_deta;

-------------------boton borrar

procedure pp_dele_asie_orig (p_asie_codi in number, 
                             p_codi_base in number)is
begin
  

    
--pp_borrar_asie_hijos (p_asie_codi);   

--Detalle del asiento contable..................
update come_asie_deta c set c.deta_base =p_codi_base
where c.deta_asie_codi = p_asie_codi;

delete from  come_asie_deta c
where c.deta_asie_codi = p_asie_codi;

update come_movi set movi_asie_codi = null
where movi_asie_codi = p_asie_codi;
  
  
--Cabecera del Asiento Contable..................
update come_asie set asie_base = p_codi_base
where asie_codi = p_asie_codi;
  
delete come_asie
where asie_codi = p_asie_codi;  
  
  -- raise_application_error (-20001,p_asie_codi||'++'||p_codi_base);
end pp_dele_asie_orig;

procedure pp_agregar_detalle( i_cuco_nume      in number, 
                              i_deta_indi_dbcr in varchar2,
                              i_deta_impo_mone in number,
                              o_debe           out number,
                              o_haber          out number,
                              o_diferencia     out number,
                              i_seq_id         in number) is
  
  v_debe number;
  v_haber number;
  v_diferencia number;
  v_desc varchar2(60);
  v_codi varchar2(60);
  v_tipo varchar2(60);
  v_nro number;
begin
 
if i_cuco_nume is null then
  raise_application_error (-20001, 'Debe ingresar el concepto');
end if;

  
if i_deta_indi_dbcr is null then
  raise_application_error (-20001, 'Debe ingrese el tipo');
end if;

if nvl(i_deta_impo_mone, 0) <=0 then   
	   raise_application_error (-20001,'El importe no puede ser menor o igual a cero');
end if;	   


 select nvl(max(c001),0) nro
       into v_nro
      from apex_collections a
     where collection_name = 'DETALLE';
     
     
     v_diferencia  := v_debe-v_haber;
     
  o_debe           :=v_debe;
  o_haber          :=v_haber;
  o_diferencia     :=v_diferencia;
if i_seq_id is null then 
     I020121.pp_muestra_come_cuen_cont(p_nume => i_cuco_nume,
                                        p_desc => v_desc,
                                        p_codi => v_codi,
                                        p_tipo => v_tipo,
                                        p_empr => 1);


    apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => v_nro+1, --usar seq_id --y.deta_nume_item,
                                 p_c002            => v_codi,--y.deta_cuco_codi,
                                 p_c003            => null,-- y.deta_ceco_codi,
                                 p_c004            => i_cuco_nume,-------
                                 p_c005            => i_deta_indi_dbcr,
                                 p_c006            => i_deta_impo_mone,
                                 p_c007            => v_desc,
                                 p_c008            => v_tipo --tipo cuenta
                                 );
 end if;       
 
 if i_seq_id is not null then
        I020121.pp_muestra_come_cuen_cont(p_nume => i_cuco_nume,
                                          p_desc => v_desc,
                                          p_codi => v_codi,
                                          p_tipo => v_tipo,
                                          p_empr => 1);
     
 
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                P_SEQ             => i_seq_id,
                                                P_ATTR_NUMBER     => 2,
                                                P_ATTR_VALUE      => v_codi);
                                                      
                                                      
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                P_SEQ             => i_seq_id,
                                                P_ATTR_NUMBER     => 4,
                                                P_ATTR_VALUE      => i_cuco_nume);                                         
                                              
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                P_SEQ             => i_seq_id,
                                                P_ATTR_NUMBER     => 5,
                                                P_ATTR_VALUE      => i_deta_indi_dbcr);  
 
         APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                P_SEQ             => i_seq_id,
                                                P_ATTR_NUMBER     => 6,
                                                P_ATTR_VALUE      => i_deta_impo_mone);
         APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                P_SEQ             => i_seq_id,
                                                P_ATTR_NUMBER     => 7,
                                                P_ATTR_VALUE      => v_desc);
         APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                P_SEQ             => i_seq_id,
                                                P_ATTR_NUMBER     => 8,
                                                P_ATTR_VALUE      => v_tipo);                                                                                   
 end if;
 
 
                          
 select nvl(sum(
           case when c005 = 'D' then
              to_number(c006)
              end),0) debe,
          nvl(sum(case when c005 = 'H' then
             to_number(c006)
              end),0) haber
       into v_debe, v_haber 
      from apex_collections a
     where collection_name = 'DETALLE';
     
     
     v_diferencia  := v_debe-v_haber;
     
  o_debe           :=v_debe;
  o_haber          :=v_haber;
  o_diferencia     :=v_diferencia;
end pp_agregar_detalle;






procedure pp_cargar_bloq (p_asti_codi in number) is
cursor c_det_asie  is
select   t.asti_desc,
         cc.cuco_nume,        
         d.tide_dbcr         
from  come_asie_tipo t,
      come_asie_tipo_deta d,
      come_cuen_cont cc
where t.asti_codi = d.tide_asti_codi
and   d.tide_cuco_codi = cc.cuco_codi
and   t.asti_codi = p_asti_codi
order by cc.cuco_nume;
  v_debe number;
  v_haber number;
  v_diferencia number;
  v_desc varchar2(60);
  v_codi varchar2(60);
  v_tipo varchar2(60);
  v_nro number :=0;
  i_cuco_nume  varchar2(60);
  i_deta_indi_dbcr  varchar2(60);
Begin 
  
 APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETALLE');
    for x in c_det_asie loop    
      i_cuco_nume                           := x.cuco_nume;                   
      i_deta_indi_dbcr                      := x.tide_dbcr;      

        I020121.pp_muestra_come_cuen_cont(p_nume => i_cuco_nume,
                                          p_desc => v_desc,
                                          p_codi => v_codi,
                                          p_tipo => v_tipo,
                                          p_empr => 1);
       v_nro :=v_nro+1;                                   
                                          
        apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => v_nro, --usar seq_id --y.deta_nume_item,
                                 p_c002            => v_codi,--y.deta_cuco_codi,
                                 p_c003            => null,-- y.deta_ceco_codi,
                                 p_c004            => i_cuco_nume,-------
                                 p_c005            => i_deta_indi_dbcr,
                                 p_c006            => null,
                                 p_c007            => v_desc,
                                 p_c008            => v_tipo --tipo cuenta
                                 );
    end loop; 
end pp_cargar_bloq;
---pp_muestra_come_cuen_cont
end I020121;
