
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020401" is

 

  procedure pp_iniciar (p_camb_soli in number,
                        p_cliente in number) is
    
  cursor deta is
     select deta_camb_plan_codi,
                 deta_camb_soli,
                 deta_camb_anex,
                 deta_camb_anex_deta,
                 deta_camb_impo_ante,
                 deta_camb_impo_nuev,
                 deta_camb_obse,
                 deta_camb_file,
                 deta_camb_esta,
                 deta_camb_user,
                 deta_camb_fech,
                 deta_camb_file_mime_type,
                 deta_camb_file_name,
                 deta_camb_id_file,
                 deta_camb_apli
      from come_soli_camb_plan_deta
   where deta_camb_plan_codi =p_camb_soli;
   
   
  cursor plan (p_anexo in number, p_anex_deta in number) is
    select anpl_indi_fact,
           anpl_deta_esta_plan,
           anpl_nume           Nro_plan,
           anpl_nume_item      item,
           anpl_fech_venc      Vto,
           anpl_fech_fact      Fecha_Fact,
           anpl_fech_desd      Desde,
           anpl_fech_hast      hasta,
           anpl_impo_mone      importe_anterior,
           anpl_anex_codi      anexo,
           anpl_deta_codi      anexo_codi
      from come_soli_serv_anex_plan c
     where c.anpl_anex_codi = p_anexo
       and c.anpl_deta_codi = p_anex_deta;
   
  v_user          varchar2(100):= GEN_USER; 
  v_nro_solicitud number;
  v_nro_anexo     number;
  v_concepto      varchar2(1000);
  v_vehiculo      varchar2(1000);
  v_tipo          varchar2(1000);
  
v_dura_cont          number;
v_precio_unit        number:= 0;
v_precio_total       number;
v_promo_libre        varchar2(2);
v_dias               number;
v_dias_mes           number;
v_importe_final      number := 0;

  begin
    
    apex_collection.create_or_truncate_collection(p_collection_name => 'PLAN');  

    apex_collection.create_or_truncate_collection(p_collection_name => 'CLIE_DET');  
    
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');  
    
    
    if p_camb_soli is not null then
    apex_collection.add_member(p_collection_name => 'CLIE_DET',
                                 p_c001           => p_cliente);  
                                 
    for x in deta loop
    
    select a.sose_nume,
           b.anex_nume,
           e.conc_desc,
           '<span>*' || vehi_mode || '</br>*' || vehi_anho || '</br>*' ||
           vehi_colo || '</br>*' || vehi_nume_pate || '</span>' vehiculo,
           decode(b.anex_tipo,'I', 'Instalacion','T', 'Cambio de Titularidad','RI', 'Reinstalacion','N','Renovacion')
      into v_nro_solicitud, v_nro_anexo, v_concepto, v_vehiculo, v_tipo
      from come_soli_serv           a,
           come_soli_serv_anex      b,
           come_soli_serv_anex_deta c,
           come_vehi                d,
           come_conc                e
     where a.sose_codi = b.anex_sose_codi
       and b.anex_codi = c.deta_anex_codi
       and c.deta_vehi_codi = d.vehi_codi
       and c.deta_conc_codi = e.conc_codi
       and c.deta_anex_codi = x.deta_camb_anex
       and c.deta_codi = x.deta_camb_anex_deta;
      
      
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001           => x.deta_camb_plan_codi,
                                 p_c002           => x.deta_camb_soli,
                                 p_c003           => x.deta_camb_anex,
                                 p_c004           => x.deta_camb_anex_deta,
                                 p_c005           => x.deta_camb_impo_ante,
                                 p_c006           => x.deta_camb_impo_nuev,
                                 p_c007           => x.deta_camb_obse,
                                 p_c008           => x.deta_camb_esta,
                                 p_C009           => x.deta_camb_file_name,
                                 p_C010           => x.deta_camb_file_mime_type,
                                 p_c011           => p_cliente,
                                 p_BLOB001        => x.deta_camb_file,
                                 p_c016           => v_nro_solicitud,
                                 p_c017           => v_nro_anexo,
                                 p_c018           => v_concepto,
                                 p_c019           => v_vehiculo,
                                 p_c020           => v_tipo,
                                 p_c021           => x.deta_camb_apli
                                 );
                                 
                                 
      -----------cargamos el plan para que puedan ver el detalle
        select anex_dura_cont,
               last_day(anex_fech_inic_vige) - anex_fech_inic_vige cant_dias,
               to_number(to_char(last_day(anex_fech_inic_vige), 'dd')) dias_mes
          into v_dura_cont,  v_dias, v_dias_mes
          from come_soli_serv_anex a
         where a.anex_codi = x.deta_camb_anex;  
                            
      select nvl(b.deta_indi_prom_pror,'N')
           into v_promo_libre
           from come_soli_serv_anex_deta b
          where b.deta_anex_codi = x.deta_camb_anex
            and b.deta_codi      = x.deta_camb_anex_deta;                            

       v_precio_unit := to_number(x.deta_camb_impo_nuev);

         for a in plan (to_number(x.deta_camb_anex), to_number(x.deta_camb_anex_deta) ) loop
                 
               if a.anpl_indi_fact = 'N'  and a.anpl_deta_esta_plan ='S'   then
            
                     if v_promo_libre  = 'S' and to_number(a.item) in (1,2) then
                          v_importe_final := (v_precio_unit/v_dias_mes)*v_dias;
                       
                     elsif v_promo_libre  = 'N' and to_number(a.item) = 1 then
                          v_importe_final := (v_precio_unit/v_dias_mes)*v_dias;
                        
                     else
                        v_importe_final := v_precio_unit;
                     end if;
                  else
                    v_importe_final := null;
                     
               end if;
                apex_collection.add_member(p_collection_name => 'PLAN',
                                           p_c001     => a.anpl_indi_fact,
                                           p_c002     => a.anpl_deta_esta_plan,
                                           p_c003     => a.Nro_plan,
                                           p_c004     => a.item,
                                           p_c005     => a.Vto,
                                           p_c006     => a.Fecha_Fact,
                                           p_c007     => a.Desde,
                                           p_c008     => a.hasta,
                                           p_c009     => a.importe_anterior,
                                           p_c010     => a.anexo,
                                           p_c012     => a.anexo_codi,
                                           P_C013     => v_importe_final);
                                
            
            end loop;                                 
                     
         
  end loop;
 
   delete temp_imagen
     where login = v_user
       and session_id = v('app_session');
                           
                                  
 insert into temp_imagen
   (img_id,
    cont_bloc,
    login,
    session_id,
    id_imagen,
    file_name,
    mime_type,
    fecha_actualizacion)
   select seq_id,
          BLOB001,
          v_user,
          V('APP_SESSION'),
          null,
          c009,
          c010,
          sysdate
     from apex_collections a
    where collection_name = 'DETALLE';

  end if;   
  
  
  

  end pp_iniciar;
 

 function fp_datos_html (p_clave          number default null,
                         p_anexo          number default null,
                         p_anex_deta      number default null) return varchar2 is
    
     cursor c_registro is                    
                     select c008 estado,
                         decode(nvl(c008, 'P'), 'A', ' checked ', null) probado,
                         decode(nvl(c008, 'P'), 'R', ' checked ', null) revisar,
                         seq_id,
                         c021 cambiar
                     from apex_collections a
                   where collection_name = 'DETALLE'
                     and c001 = p_clave
                     and c003 = p_anexo
                     and c004 = p_anex_deta;
     
v_adjunto     varchar(32000);
v_adjunto2    varchar(32000);
v_descripcion varchar2(32000);
v_where       number;     
v_dato        varchar2(32000);    
v_tabla       varchar2(32000);
sql_stmt      varchar2(32000);
v_cambia      varchar2(32000);
v_id          varchar2(32000);
v_dato2       varchar2(1000);
v_datow       varchar2(1000);

 begin
   --raise_application_error(-20001,p_clave||'-'||p_anexo||'-'||p_anex_deta );
   
   V_ADJUNTO := V_ADJUNTO ||'<PRE style="font-size:15px;">';
   V_ADJUNTO := V_ADJUNTO || '<b>'||RPAD('Aprobar', 8, ' ')||RPAD('Rechazar', 10, ' ')||'</b><br><br>' ;
 
  FOR R IN C_REGISTRO  LOOP
    if r.cambiar  = 'N' then
     V_ADJUNTO :=V_ADJUNTO||'<input type="radio" '||R.PROBADO||' onclick=javascript:$s("P121_ID",'||R.SEQ_ID||');javascript:$s("P121_TIPO","A"); id="'||P_ANEX_DETA||'age1" name="'||R.SEQ_ID||P_ANEX_DETA||'">      <input type="radio" '||R.REVISAR||' onclick=javascript:$s("P121_ID",'||R.SEQ_ID||');javascript:$s("P121_TIPO","R"); id="'||P_ANEX_DETA||'age2" name="'||R.SEQ_ID||P_ANEX_DETA||'"></br>';
    end if;
  END LOOP;

  return  v_adjunto||'</PRE>';

  
  
 end fp_datos_html;


procedure pp_actualizar (p_camb_codi in number)is
  
cursor cambi is
  select c001    camb_soli,
         c002    solicitud,
         c003    anexo,
         c004    nro_anexo,
         c008    estado,
         seq_id,
         c006    nuevo_importe
     from apex_collections a
    where collection_name = 'DETALLE'
      and c021 = 'N'
      and c008 <> 'P';
 
cursor plan (p_anexo_a     in number, 
             p_anex_deta_a in number) is
    select c.anpl_impo_mone,anpl_nume_item, anpl_codi
    from come_soli_serv_anex_plan c
    where c.anpl_anex_codi = p_anexo_a
    and c.anpl_deta_codi = p_anex_deta_a
    and anpl_indi_fact = 'N'
    and anpl_deta_esta_plan ='S';

v_user varchar2(20) :=gen_user;
v_dura_cont          number;
v_precio_unit        number;
v_precio_total       number;
v_promo_libre        varchar2(2);
v_desde              date;
v_hasta              date;
v_dias               number;
v_dias_mes           number;
v_importe_final      number := 0;
v_cant_aprobado      number;
v_cant_item          number;
begin
  ----------actualizamos el estado de la come_soli_camb_plan_deta


  for x in cambi loop
   if  x.estado = 'A' then
     
        update come_soli_camb_plan_deta
           set deta_camb_esta = x.estado,
               deta_camb_user = v_user,
               deta_camb_fech = sysdate,
               deta_camb_apli = 'S'
         where deta_camb_plan_codi = x.camb_soli
           and deta_camb_anex = x.anexo
           and deta_camb_anex_deta = x.nro_anexo;

        select anex_dura_cont,
               anex_fech_inic_vige,
               anex_fech_vige,
               last_day(anex_fech_inic_vige) - anex_fech_inic_vige cant_dias,
               to_number(to_char(last_day(anex_fech_inic_vige), 'dd')) dias_mes
          into v_dura_cont, v_desde, v_hasta, v_dias, v_dias_mes
          from come_soli_serv_anex a
         where a.anex_codi = x.anexo;
         
         
         select  nvl(b.deta_indi_prom_pror,'N')
           into v_promo_libre
           from come_soli_serv_anex_deta b
          where b.deta_anex_codi = x.anexo
            and b.deta_codi = x.nro_anexo;

        v_precio_unit := x.nuevo_importe;
        v_precio_total :=  v_precio_unit*v_dura_cont;
       
        /*UPDATE come_soli_serv_anex a
           SET a.anex_prec_unit, 
            anex_entr_inic, 
            anex_impo_mone, 
            anex_impo_mmnn,
            anex_dura_cont
       from come_soli_serv_anex a
      where a.anex_codi =15334 ;*/

        update come_soli_serv_anex_deta
         set deta_prec_unit = v_precio_unit,
             deta_impo_mone = v_precio_total
        where deta_anex_codi = x.anexo
          and deta_codi      = x.nro_anexo;


           for a in plan (x.anexo,x.nro_anexo ) loop
            
           if v_promo_libre  = 'S' and a.anpl_nume_item in (1,2) then
            v_importe_final := (v_precio_unit/v_dias_mes)*v_dias;
           elsif v_promo_libre  = 'N' and a.anpl_nume_item in (1) then
            v_importe_final := (v_precio_unit/v_dias_mes)*v_dias;
           else
            v_importe_final := v_precio_unit;
           end if;
           
            
            update come_soli_serv_anex_plan 
              set anpl_impo_mone = v_importe_final
            where anpl_codi = a.anpl_codi;
           
           
           end loop;  
   else
      update come_soli_camb_plan_deta
           set deta_camb_esta = x.estado,
               deta_camb_user = v_user,
               deta_camb_fech = sysdate,
               deta_camb_apli = 'S'
         where deta_camb_plan_codi = x.camb_soli
           and deta_camb_anex = x.anexo
           and deta_camb_anex_deta = x.nro_anexo;       
            
   end if;
 end loop;
 
 
select count(deta_camb_plan_codi)
  into v_cant_aprobado
  from come_soli_camb_plan_deta t
 where deta_camb_apli = 'S'
   and deta_camb_plan_codi = p_camb_codi;

select count(deta_camb_plan_codi)
  into v_cant_item
  from come_soli_camb_plan_deta t
 where deta_camb_plan_codi = p_camb_codi;
 
 
 if v_cant_aprobado = v_cant_item  then
 update come_soli_camb_plan a
    set a.camb_plan_esta = 'F',    ---finalizado
        camb_plan_auto_user = v_user,
        camb_plan_auto_fech = sysdate
  where camb_plan_codigo = p_camb_codi;
  
  else 
     update come_soli_camb_plan a
    set a.camb_plan_esta = 'EP',---en proceso
        camb_plan_auto_user = v_user,
        camb_plan_auto_fech = sysdate    
  where camb_plan_codigo = p_camb_codi;
 end if;
 
end pp_actualizar;


procedure pp_cant_cuot_venc (p_cliente in number,
                             p_cuotas  out number) is
                             
begin
 
 select nvl(max(cant_cuot_venc),0)
   into p_cuotas
   from come_temp_cuot_pend_v t
  where clpr_codi = p_cliente;
exception when no_data_found then
  
p_cuotas := 0;

end pp_cant_cuot_venc;        

end I020401;
