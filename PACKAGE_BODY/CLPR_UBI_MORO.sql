
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."CLPR_UBI_MORO" is
type r_parameter is record(
    p_usuario                  varchar2(100) := fp_user,
    p_empr_codi                number := 1,
    p_codi_base                number := pack_repl.fa_devu_codi_base,
    p_indi_most_mens_sali      varchar(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_most_mens_sali')))),
    p_codi_tipo_empl_vend      varchar(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')))),
    p_impo_mone_anex_rein_vehi number := to_number(general_skn.fl_busca_parametro('p_impo_mone_anex_rein_vehi')),
    p_conc_codi_anex_rein_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_rein_vehi')),
    p_conc_codi_serv_moni_anua number := to_number(general_skn.fl_busca_parametro('p_conc_codi_serv_moni_anua')),
    p_conc_codi_serv_moni_mens number := to_number(general_skn.fl_busca_parametro('p_conc_codi_serv_moni_mens')),
    p_conc_codi_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_grua_vehi')),
    p_prec_unit_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_prec_unit_anex_grua_vehi')));
  parameter r_parameter;
  
  --comentario agregado por Juan para prueba de github borrar de nuevo
  -- hola
  
procedure pp_ubi_clientes (p_tail out varchar2,
                           p_ubi  in varchar2,
                           p_lat  out varchar2,
                           p_lng  out varchar2) is
 
    v_host      varchar2(2000);
    v_mail      varchar2(2000);
    v_pass      varchar2(2000);
    v_hash      varchar2(2000);
    v_url       varchar2(2000);
    vl_url      varchar2(2000);
    v_json      clob;
    v_item      number;
    v_sens      number;
    v_item_actu number;
    v_devi_ante number:=0;
    v_rowid     rowid;
  
    v_logm_fech       date;
    v_logm_user       varchar2(20);
    v_logm_proc       varchar2(100);
    v_logm_cant_erro  number(10);
    v_logm_inde       number(10);
    v_logm_erro_mens  varchar2(500);
    v_logm_erro_code  number(10);
  
   type tt_devi_esta is table of mapa_devi_esta%rowtype index by binary_integer;
    type tt_devi_actu is table of rowid index by binary_integer;
   ta_devi_esta tt_devi_esta;
    ta_devi_upda tt_devi_esta;
    ta_devi_actu tt_devi_actu;
  
   -- ex_dml_errors exception;
    --pragma exception_init(ex_dml_errors, -24381);
    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_param   varchar2(32000);
    
    v_ultima_pagina number;
    v_aux           varchar2(100);
    v_ult_letra     varchar2(2000);
    p_device        number;
    
    v_param2   varchar2(32000);
     
    km_distancia varchar2(1000);
    mts_distancia varchar2(1000);
    enlace varchar2(1000);
    v_indicador number;
    
    tail   varchar2(32000);
    
    v_lat number;
    v_lng number;
    v_ubi varchar2(2000);
    
     v_clim_visitado varchar2(100);
    v_clim_fech_visi  date;
    
    v_id_dispositivo number;
    v_cliente number;
    v_chasis varchar2(100);
    v_obser1 varchar2(1000);
    v_obser2 varchar2(1000);
    v_fecha date;
    v_desi varchar2(1);
  begin
  --   raise_Application_error(-20001,p_ubi);
  --raise_Application_error(-20001,v('P51_UBI'));
  
  
  v_ubi := replace(replace(p_ubi,')',''),'(','');
  
  select to_number(replace(ubicacion,'.',','))
  into v_lat
    from (select regexp_substr(v_ubi, '[^,]+', 1, level) ubicacion, level nro
            from dual
          connect by regexp_substr(v_ubi, '[^,]+', 1, level) is not null)
   where nro = 1;
     
   
     
   -- raise_application_error(-20001, v_ubi);
    select to_number(replace(ubicacion,'.',','))
     into v_lng
    from (select regexp_substr(v_ubi, '[^,]+', 1, level) ubicacion, level nro
            from dual
          connect by regexp_substr(v_ubi, '[^,]+', 1, level) is not null)
   where nro = 2;

  
     p_lat := replace(v_lat,',','.');
     p_lng  :=replace(v_lng,',','.');
  
   APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(P_COLLECTION_NAME => 'CLIE_MOROSOS');
  
  
      for k in  (  select device_id,
                          time_data,
                          device_name,
                          lastvalidlatitude,
                          lastvalidlongitude,
                          emei,
                          sim_number,
                          plate_number,
                          clim_visitado,
                          clim_fech_visi,
                          cliente,
                          obser1,
                          obser2,
                          fecha,
                          desi,
                          CANT_CUO_VENC
                     from mapa_moro_ubic
                     where cliente is not null ) loop


if k.cliente is not null then
  

   if k.device_id != v_devi_ante then
  -- raise_Application_error(-20001,  k.cliente);    
     if k.lastvalidlatitude is not null then  
     
         km_distancia := CLPR_UBI_MORO.pp_distancia(p_latitude1  => v_lat,
                                                    p_longitude1 => v_lng,
                                                    p_latitude2  => replace(k.lastvalidlatitude,'.',','),
                                                    p_longitude2 => replace(k.lastvalidlongitude,'.',','));
                                                
         mts_distancia := km_distancia*1000;  
         enlace := 'https://maps.google.com/?q='||k.lastvalidlatitude|| ',' ||k.lastvalidlongitude ;                                         
     
     if trunc(mts_distancia)<= 3000 then
       v_indicador := 1;
       tail:=tail||k.lastvalidlatitude|| ',' ||k.lastvalidlongitude|| ','||substr(k.device_name, 1, 100)|| '|';
     else
       v_indicador :=0;
     end if;
      else
        mts_distancia:= null;
        km_distancia :=null;
        enlace := null;
           
      end if;
  
   
                    apex_collection.add_member(p_collection_name => 'CLIE_MOROSOS',
                                 p_c001            => k.device_id,
                                 p_c002            => null,--substr(k.online_data, 1, 100),
                                 p_c003            => to_date(k.time_data, 'dd-mm-yyyy hh24:mi:ss'),
                                 p_c004            => null,--substr(k.icon_color, 1, 100),
                                 p_c005            => null,--substr(k.tail, 1, 2000),
                                 p_c006            => k.device_name, 
                                 p_c007            => null,-- substr(k.stop_duration, 1, 100),
                                 p_c008            => k.lastvalidlatitude,
                                 p_c009            => k.lastvalidlongitude,
                                 p_c010            => null,--substr(k.speed, 1, 10),
                                 p_c011            => null,--substr(k.course, 1, 10),
                                 p_c012            => k.emei,
                                 p_c013            => k.sim_number,
                                 p_c014            => null,--k.object_owner,
                                 p_c015            => k.device_name,
                                 p_c016            => k.plate_number,
                                 p_c017            => round(km_distancia,3),
                                 p_c018            => round(mts_distancia,3),
                                 p_c019            => enlace,
                                 p_c020            => v_indicador,
                                 p_c021            => null,---se usa mas tarde
                                 p_c022            => k.clim_visitado,
                                 p_c023            => k.clim_fech_visi,
                                 p_c024            => k.cliente,
                                 p_c025            => k.obser1,
                                 p_c026            => k.obser2,
                                 p_c027            => k.fecha,
                                 p_c028            => k.desi,
                                 P_C029            => K.CANT_CUO_VENC);
                   v_devi_ante := k.device_id;
       end if;
   end if;
     end loop;

--end loop;


tail :=replace(tail||'*', '|*','');
p_tail := tail;


end pp_ubi_clientes ;


 function pp_distancia (p_latitude1  number,
                        p_longitude1 number,
                        p_latitude2  number,
                        p_longitude2 number) return number
  deterministic is
  earth_radius number := 6371;
  pi_approx    number := 3.1415927 / 180;
  lat_delta    number := (p_latitude2 - p_latitude1) * pi_approx;
  lon_delta    number := (p_longitude2 - p_longitude1) * pi_approx;
  arc          number := sin(lat_delta / 2) * sin(lat_delta / 2) +
                         sin(lon_delta / 2) * sin(lon_delta / 2) *
                         cos(p_latitude1 * pi_approx) *
                         cos(p_latitude2 * pi_approx);
begin
  return earth_radius * 2 * atan2(sqrt(arc), sqrt(1 - arc));
end pp_distancia;


  procedure pp_enlace_mapa (p_dispositivo in number,
                          p_tipo        in varchar2,
                          p_hora        in number,
                          p_fecha       in varchar2,
                          p_eliminar    in number,
                          p_seq_id      in number)is
  
    v_param   varchar2(32000);
    v_url     varchar2(4000);
    v_status  varchar2(20);
    v_mensaje varchar2(1000);
    v_hash    varchar2(1000);

    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_comp_host varchar2(100);
     v_fecha varchar2(200);--date;
    v_seq_mapa_enlace number;
    
    v_enlace varchar2(20000);
    v_hash_enla varchar2(5000);
 begin
-- raise_application_error (-20001,'asdf');
   begin
    select t.comp_user, t.comp_pass, t.comp_host
      into v_comp_user, v_comp_pass, v_comp_host
      from segu_comp_sist t
     where comp_empr_codi = 1;

       

      apex_json.initialize_clob_output;
      apex_json.open_object;
      apex_json.write('email', v_comp_user);
      apex_json.write('password', v_comp_pass);     
      apex_json.close_object;

      v_param := apex_json.get_clob_output;
      apex_json.free_output;

      pack_mapas_gpswox.pa_obtiene_hash(v_param, v_hash);
  
  end;
  
   if p_tipo  = 'D'  then
  
  select to_char((sysdate + p_hora / (60 * 24)), 'yyyy/mm/dd hh24:mi')
    into v_fecha
    from dual;
        else
      v_fecha :=p_fecha;
  end if;

  
  --raise_application_error(-20001, 'prueba');

       
   select seq_mapa_enlace.nextval into v_seq_mapa_enlace from dual;
       
     v_url := v_comp_host||'/api/sharing?user_api_hash='||v_hash;
      
        v_param := 'active='                             || apex_util.url_encode(1)                    ||chr(38) 
                || 'name='                               || apex_util.url_encode('Compartir enlace '||v_seq_mapa_enlace)   ||chr(38) 
                || 'enable_expiration_date='             || apex_util.url_encode(1)                    ||chr(38) 
                || 'expiration_date='                    || apex_util.url_encode(v_fecha)              ||chr(38) 
                || 'delete_after_expiration='            || apex_util.url_encode(p_eliminar)           ||chr(38) 
                || 'devices[]='                          || apex_util.url_encode(p_dispositivo);
                

         PACK_MONITOREO.pa_upd_clpr_mapa(v_url, v_param, v_status, v_mensaje, v_hash_enla);
      --  v_hash_enla := null;
            if v_status = '1' or v_status is null then
              v_enlace:= 'https://gps.alarmas.com.py/sharing/'||v_hash_enla;
              ---       v_enlace:= 'https://gps.alarmas.com.py/sharing/'||v_hash_enla;
              
              
                  insert into mapa_enlace
                    (menl_codigo,
                     menl_disp,
                     menl_nombre,
                     menl_fec_cad,
                     menl_caducidad,
                     menl_elim_cad,
                     menl_estado,
                     menl_tipo,
                     menl_enlace)
                  values
                    (v_seq_mapa_enlace,
                     p_dispositivo,
                     'Compartir enlace '||v_seq_mapa_enlace,
                     1,
                     v_fecha,
                     p_eliminar,
                     1,
                     p_tipo,
                     v_enlace);
                     
                     APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE( p_collection_name => 'CLIE_MOROSOS',
                                                              p_seq             => p_seq_id,
                                                              p_attr_number     => 21,
                                                              p_attr_value      => v_enlace);
            else 
              null;
            end if;  

        dbms_output.put_line ('estado:'||v_status||'   url:'||v_url||  'parametros:'||v_param||'  mensaje:'||v_mensaje) ;

  

end pp_enlace_mapa;


procedure pp_agregar_visita (p_cliente     in number,
                             p_dispositivo in number,
                             p_seq_id      in number default null)is
  v_user varchar2(2000):= fp_user;
  begin

    
  update mapa_ubic_clie_moro
     set clim_visitado = 'S',
         clim_fech_visi = sysdate,
         clim_login_visi = v_user
   where clim_cliente = p_cliente
     and clim_dispo = p_dispositivo;
  
  insert into mapa_clie_moro_fech
    (clim_codigo, clim_dispositivo, clim_fech_visita, clim_user)
  values
    (p_cliente, p_dispositivo, sysdate, v_user);
   
  if p_seq_id is not null then
   APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE( p_collection_name => 'CLIE_MOROSOS',
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 23,
                                            p_attr_value      => sysdate);
                                            
   APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE( p_collection_name => 'CLIE_MOROSOS',
                                            p_seq             => p_seq_id,
                                            p_attr_number     => 22,
                                            p_attr_value      => fp_user);                                         
    
  end if; 
    
  end pp_agregar_visita;
  
 procedure pp_act_ubi_cliente is
   
 v_comp_host      varchar2(2000);
    v_mail      varchar2(2000);
    v_pass      varchar2(2000);
    v_hash      varchar2(2000);
    v_url       varchar2(2000);
    vl_url      varchar2(2000);
    v_json      clob;
    v_item      number;
    v_sens      number;
    v_item_actu number;
    v_devi_ante number;
    v_rowid     rowid;
  
    v_logm_fech       date;
    v_logm_user       varchar2(20);
    v_logm_proc       varchar2(100);
    v_logm_cant_erro  number(10);
    v_logm_inde       number(10);
    v_logm_erro_mens  varchar2(500);
    v_logm_erro_code  number(10);
  
   type tt_devi_esta is table of mapa_devi_esta%rowtype index by binary_integer;
    type tt_devi_actu is table of rowid index by binary_integer;
   ta_devi_esta tt_devi_esta;
    ta_devi_upda tt_devi_esta;
    ta_devi_actu tt_devi_actu;
  
   -- ex_dml_errors exception;
    --pragma exception_init(ex_dml_errors, -24381);
    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_param   varchar2(32000);
    
    v_ultima_pagina number;
    v_aux           varchar2(100);
    v_ult_letra     varchar2(2000);
    p_device        number;
    
    v_param2   varchar2(32000);
     
    km_distancia varchar2(1000);
    mts_distancia varchar2(1000);
    enlace varchar2(1000);
    v_indicador number;
    
    tail   varchar2(32000);
    
    v_lat number;
    v_lng number;
    v_ubi varchar2(2000);
    
     v_clim_visitado varchar2(100);
    v_clim_fech_visi  date;
    
    v_id_dispositivo number;
    v_cliente number;
    v_chasis varchar2(100);
    v_obser1 varchar2(1000);
    v_obser2 varchar2(1000);
    v_fecha date;
    v_desi varchar2(1);
    v_cant_cuo_venci number;
  begin

    begin
     
    select t.comp_host
      into v_comp_host
      from segu_comp_sist t
     where comp_empr_codi = 1;

    
    end;
  
    
     begin
      /*    select t.comp_user, t.comp_pass, t.comp_host
      into v_comp_user, v_comp_pass, v_comp_host
      from segu_comp_sist t
     where comp_empr_codi = 1;;*/
       
       ------------------------------------------------lv24/04/2023
    v_comp_user := 'morosos@alarmas.com.py';
    v_comp_pass := 'Morosos#2023$';
      

      apex_json.initialize_clob_output;
      apex_json.open_object;
      apex_json.write('email', v_comp_user);
      apex_json.write('password', v_comp_pass);     
      apex_json.close_object;

      v_param := apex_json.get_clob_output;
      apex_json.free_output;

      pack_mapas_gpswox.pa_obtiene_hash(v_param, v_hash);
  
  end;
  delete mapa_moro_ubic;

    if v_hash is not null then
     v_url := v_comp_host || '/api/get_devices?lang=es&user_api_hash='||v_hash;--||'&id='||p_device;
                                                 
          v_json := (apex_web_service.make_rest_request(p_url         => v_url,
                                                        p_http_method => 'GET',
                                                        p_transfer_timeout => 300));

  
      v_item      := 0;
      v_item_actu := 0;
      v_sens      := 4;
      v_devi_ante := -1;
      
  
       
 if v_json like '%}]}]%' then
    v_json := replace (v_json,'}]}]','}]}]}');
  end if;
  
      
      if v_json like '%,"items":[{"id":%'  then
         v_json := replace (v_json,',"items":[{"id":',',"items":**"id":');
      end if;
      
      if v_json like '%,"sensors":[{"id":%'  then
         v_json := replace (v_json,',"sensors":[{"id":',',"sensors":**"id":');
      end if;
      
      if v_json like '%,"users":[{"id":%'  then
         v_json := replace (v_json,',"users":[{"id":',',"users":**"id":');
      end if;
     
      if v_json like '%,"services":[{"id":%'  then
         v_json := replace (v_json,',"services":[{"id":',',"services":**"id":');
      end if;
      
     ------------------------**
      if v_json like '%[{"id":%'  then
         v_json := replace (v_json,'[{"id":','{"grupo":[{"id":');
      end if;
      
      if v_json like  '%,"items":**"id":%'  then
         v_json := replace (v_json,',"items":**"id":', ',"items":[{"id":');
      end if;
      
      if v_json like '%,"sensors":**"id":%'  then
         v_json := replace (v_json,',"sensors":**"id":',',"sensors":[{"id":');
      end if;
      
      if v_json like '%,"users":**"id":%'  then
         v_json := replace (v_json,',"users":**"id":',',"users":[{"id":');
      end if;
       
      if v_json like '%,"services":**"id":%'  then
         v_json := replace (v_json,',"services":**"id":',',"services":[{"id":');
      end if;
     
      if v_json like '%"tail":[{"lat":"%' then
         v_json := replace (v_json,'"tail":[{"lat":"', '"tail":"[{\"lat\":\"');
      end if;

      if v_json like '%","lng":"%' then
         v_json :=replace (v_json,'","lng":"', '\",\"lng\":\"');
     end if;
     
     if v_json like '%"},{"lat":"%' then
        v_json := replace (v_json,'"},{"lat":"','\"},{\"lat\":\"');
     end if;
     
     if v_json like '%"}],"distance_unit_hour":%' then
        v_json := replace (v_json,'"}],"distance_unit_hour":','\"}]","distance_unit_hour":');
     end if; 
   
     if v_json like '%Tomy''O%' then
       v_json := replace (v_json,'Tomy''O','Tomy O');
     end if;
      
     if v_json like '%Tomy''O%' then
        v_json := replace (v_json,'Tomy''O','Tomy O');
     end if;

     if v_json like '%D''ecclesiis%' then
        v_json := replace (v_json,'D''ecclesiis','Decclesiis');
     end if;

     if v_json like '%d''ecclesiis@gmail%' then
        v_json := replace (v_json,'d''ecclesiis@gmail','decclesiis@gmail');
     end if;

     if v_json like '%KMJWWH7HPYU2''994%' then
        v_json := replace (v_json,'KMJWWH7HPYU2''994','KMJWWH7HPYU2994');
     end if;

  

      for k in (select 1 status,
                       j.message,
                       j.online_data,
                       decode(j.time_data,'No conectado','',j.time_data )time_data,
                       j.icon_color,
                       j.tail,
                       j.device_id,
                       j.device_name,
                       j.stop_duration,
                       replace(j.lastvalidlatitude,'.',',')lastvalidlatitude,
                       replace(j.lastvalidlongitude,'.',',')lastvalidlongitude,
                       j.speed,
                       j.course,
                     --  j.sensor_name,
                      -- j.sensor_value,
                      -- j.unit_of_measurement,
                       j.emei,
                       sim_number,
                       object_owner,
                       plate_number
                  from json_table(v_json,
                                   '$'
                                      columns(
                                   nested path '$.grupo[*]'
                                          columns(
                                status number path '$.id',
                                          message varchar2 path '$.title',
                                          nested path '$.items[*]'
                                          columns(online_data varchar2 path '$.online',
                                                  time_data varchar2 path '$.time',
                                                  icon_color varchar2 path '$.icon_color',
                                                  tail varchar2 path '$.tail',
                                                  nested path '$.device_data'
                                                  columns(device_id varchar2 path '$.id',
                                                          device_name varchar2 path '$.name',
                                                        stop_duration varchar2 path '$.stop_duration',
                                                        emei varchar2 path '$.imei',
                                                         sim_number varchar2 path '$.sim_number', 
                                                         object_owner varchar2 path '$.object_owner', 
                                                            plate_number varchar2 path '$.plate_number', 
                                                         nested path '$.traccar'
                                                          columns(lastvalidlatitude varchar2 path '$.lastValidLatitude',
                                                                  lastvalidlongitude varchar2 path '$.lastValidLongitude',
                                                                  speed varchar2 path '$.speed',
                                                                  course varchar2 path '$.course')))))) j
                                                                  ) loop
   
  
 
  begin
     select a.gmch_id id_dispositivo, b.ctcp_clpr_codi cliente, gmch_chasis, ctcp_cant_cuot_venc
     into  v_id_dispositivo, v_cliente,  v_chasis, v_cant_cuo_venci
              from come_mapa_get_chas_mail a, come_temp_cuot_pend b
             where a.gmch_chasis = b.ctcp_vehi_nume_chas
              and b.ctcp_cant_cuot_venc >= 4
               and gmch_id = k.device_id
               group by a.gmch_id , b.ctcp_clpr_codi, gmch_chasis,ctcp_cant_cuot_venc;
   exception
       when others then
         v_cliente := null ;
         
     end;
if v_cliente is not null then
  

   if nvl(k.status, 1) != 1 then
          raise_application_error(-20000, k.message);
   end if;
       
   if k.device_id != v_devi_ante then
   

  
 begin
 select t.ortr_desc_prob, ortr_serv_obse, t.ortr_fech_emis,'D'
    into v_obser1,        v_obser2, v_fecha, v_desi 
   from come_orde_trab t, come_vehi s
  where ortr_vehi_codi = s.vehi_codi
    and t.ortr_clpr_codi = v_cliente
    and ortr_serv_tipo = 'D'
    and s.vehi_nume_chas =v_chasis;
  exception 
    when others then
      v_obser1 := null;    
      v_obser2 := null;
      v_fecha  := null;
      v_desi   := null;
    end ;
  
  begin
   select s.clim_login_visi, clim_fech_visi
     into v_clim_visitado, v_clim_fech_visi
     from mapa_ubic_clie_moro s
    where clim_cliente =v_cliente 
      and clim_dispo = v_id_dispositivo;
      
      if v_desi is not null then
       update mapa_ubic_clie_moro s
          set s.clim_desi =v_desi,
              s.clim_desi_obs1 = v_obser1,
              s.clim_desi_obs2 = v_obser2,
               s.clim_desi_fec = v_fecha
          where s.clim_cliente = v_cliente
            and s.clim_dispo =v_id_dispositivo;
            
           
      end if;
      
  exception
  when no_data_found then
    v_clim_visitado:= null;
    v_clim_fech_visi:= null;

  
  insert into mapa_ubic_clie_moro 
    (clim_nombre,
     clim_fech_grab,
     clim_visitado,
     clim_fech_visi,
     clim_dispo,
     clim_cliente,
     clim_desi,
     clim_desi_obs1,
     clim_desi_obs2,
     clim_desi_fec)
  values
    (substr(k.device_name, 1, 100),
     sysdate, --,+clim_visitado,
     null,-- clim_fech_visi,
     null,
     v_id_dispositivo,
     v_cliente,
     v_desi,
     v_obser1,    
     v_obser2,
     v_fecha);
  
  end; 
      insert into mapa_moro_ubic
        (device_id,
         time_data,
         device_name,
         lastvalidlatitude,
         lastvalidlongitude,
         emei,
         sim_number,
         plate_number,
         clim_visitado,
         clim_fech_visi,
         cliente,
         obser1,
         obser2,
         fecha,
         desi,
         CANT_CUO_VENC)
      values
        (k.device_id,
         to_date(k.time_data, 'dd-mm-yyyy hh24:mi:ss'),
         substr(k.device_name, 1, 100),
         replace(k.lastvalidlatitude,',','.'),
         replace(k.lastvalidlongitude,',','.'),
         k.emei,
         k.sim_number,
         k.plate_number,
         v_clim_visitado,
         v_clim_fech_visi,
         v_cliente,
         v_obser1,
         v_obser2,
         v_fecha,
         v_desi,
         v_cant_cuo_venci);
                  
  v_devi_ante := k.device_id;
     
  
  
  
    end if;
   end if;
   
   
    insert into mapa_moro_ubic
        (device_id,
         time_data,
         device_name,
         lastvalidlatitude,
         lastvalidlongitude,
         emei,
         sim_number,
         plate_number,
         clim_visitado,
         clim_fech_visi,
         cliente,
         obser1,
         obser2,
         fecha,
         desi,
         CANT_CUO_VENC)
      values
        (k.device_id,
         to_date(k.time_data, 'dd-mm-yyyy hh24:mi:ss'),
         substr(k.device_name, 1, 100),
         replace(k.lastvalidlatitude,',','.'),
         replace(k.lastvalidlongitude,',','.'),
         k.emei,
         k.sim_number,
         k.plate_number,
         v_clim_visitado,
         v_clim_fech_visi,
         v_cliente,
         v_obser1,
         v_obser2,
         v_fecha,
         v_desi,
         v_cant_cuo_venci);
                  

     end loop;
  end if;
commit;
 end  pp_act_ubi_cliente;
  
  
 
 procedure pp_ubi_tecn_clie (p_tecnico  in varchar2,
                             p_tail out varchar2,
                             p_lat  out varchar2,
                             p_lng  out varchar2) is
 
    v_host      varchar2(2000);
    v_mail      varchar2(2000);
    v_pass      varchar2(2000);
    v_hash      varchar2(2000);
    v_url       varchar2(2000);
    vl_url      varchar2(2000);
    v_json      clob;
    v_item      number;
    v_sens      number;
    v_item_actu number;
    v_devi_ante number:=0;
    v_rowid     rowid;
  
    v_logm_fech       date;
    v_logm_user       varchar2(20);
    v_logm_proc       varchar2(100);
    v_logm_cant_erro  number(10);
    v_logm_inde       number(10);
    v_logm_erro_mens  varchar2(500);
    v_logm_erro_code  number(10);
  
   type tt_devi_esta is table of mapa_devi_esta%rowtype index by binary_integer;
    type tt_devi_actu is table of rowid index by binary_integer;
   ta_devi_esta tt_devi_esta;
    ta_devi_upda tt_devi_esta;
    ta_devi_actu tt_devi_actu;
  
   -- ex_dml_errors exception;
    --pragma exception_init(ex_dml_errors, -24381);
    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_param   varchar2(32000);
    
    v_ultima_pagina number;
    v_aux           varchar2(100);
    v_ult_letra     varchar2(2000);
    p_device        number;
    
    v_param2   varchar2(32000);
     
    km_distancia varchar2(1000);
    mts_distancia varchar2(1000);
    enlace varchar2(1000);
    v_indicador number;
    
    tail   varchar2(32000);
    
    v_lat number;
    v_lng number;
    v_ubi varchar2(2000);
    
     v_clim_visitado varchar2(100);
    v_clim_fech_visi  date;
    
    v_id_dispositivo number;
    v_cliente number;
    v_chasis varchar2(100);
    v_obser1 varchar2(1000);
    v_obser2 varchar2(1000);
    v_fecha date;
    v_desi varchar2(1);
    v_tran_id_mapa number;
  begin
 
  ----------------buscamos el dispositivo asignado al tecnico
      select x.tran_id_mapa
        into v_tran_id_mapa
        from come_tran x
       where x.tran_empl = p_tecnico;
       
       
 
 ----------------buscamo la ubicacion del tecnico en el mapa
    select t.lastvalidlatitude, t.lastvalidlongitude
      into p_lat,p_lng
      from mapa_moro_ubic t
     where t.device_id = v_tran_id_mapa;
     
     
     v_lat := replace(p_lat,'.',',');
     v_lng  :=replace(p_lng,'.',',');
 --raise_application_error(-20001,v_lat||'--'||v_lng);
  --------------ya empezamos a buscar los clientes que esten cerca del tecnico
  
   APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(P_COLLECTION_NAME => 'CLIE_MOROSOS');
  
  
      for k in  (  select device_id,
                          time_data,
                          device_name,
                          lastvalidlatitude,
                          lastvalidlongitude,
                          emei,
                          sim_number,
                          plate_number,
                          clim_visitado,
                          clim_fech_visi,
                          cliente,
                          obser1,
                          obser2,
                          fecha,
                          desi,
                          CANT_CUO_VENC
                     from mapa_moro_ubic
                     where cliente is not null ) loop


if k.cliente is not null then
  

   if k.device_id != v_devi_ante then
  -- raise_Application_error(-20001,  k.cliente);    
     if k.lastvalidlatitude is not null then  
     
         km_distancia := CLPR_UBI_MORO.pp_distancia(p_latitude1  => v_lat,
                                                    p_longitude1 => v_lng,
                                                    p_latitude2  => replace(k.lastvalidlatitude,'.',','),
                                                    p_longitude2 => replace(k.lastvalidlongitude,'.',','));
                                                
         mts_distancia := km_distancia*1000;  
         enlace := 'https://maps.google.com/?q='||k.lastvalidlatitude|| ',' ||k.lastvalidlongitude ;                                         
     
     if trunc(mts_distancia)<= 3000 then
       v_indicador := 1;
      -- tail:=tail||k.lastvalidlatitude|| ',' ||k.lastvalidlongitude|| ','||substr(k.device_name, 1, 100)|| '|';
     else
       v_indicador :=0;
     end if;
      else
        mts_distancia:= null;
        km_distancia :=null;
        enlace := null;
           
      end if;
  
   
                    apex_collection.add_member(p_collection_name => 'CLIE_MOROSOS',
                                 p_c001            => k.device_id,
                                 p_c002            => null,--substr(k.online_data, 1, 100),
                                 p_c003            => to_date(k.time_data, 'dd-mm-yyyy hh24:mi:ss'),
                                 p_c004            => null,--substr(k.icon_color, 1, 100),
                                 p_c005            => null,--substr(k.tail, 1, 2000),
                                 p_c006            => k.device_name, 
                                 p_c007            => null,-- substr(k.stop_duration, 1, 100),
                                 p_c008            => k.lastvalidlatitude,
                                 p_c009            => k.lastvalidlongitude,
                                 p_c010            => null,--substr(k.speed, 1, 10),
                                 p_c011            => null,--substr(k.course, 1, 10),
                                 p_c012            => k.emei,
                                 p_c013            => k.sim_number,
                                 p_c014            => null,--k.object_owner,
                                 p_c015            => k.device_name,
                                 p_c016            => k.plate_number,
                                 p_c017            => round(km_distancia,3),
                                 p_c018            => round(mts_distancia,3),
                                 p_c019            => enlace,
                                 p_c020            => v_indicador,
                                 p_c021            => null,---se usa mas tarde
                                 p_c022            => k.clim_visitado,
                                 p_c023            => k.clim_fech_visi,
                                 p_c024            => k.cliente,
                                 p_c025            => k.obser1,
                                 p_c026            => k.obser2,
                                 p_c027            => k.fecha,
                                 p_c028            => k.desi,
                                 P_C029            => K.CANT_CUO_VENC);
                   v_devi_ante := k.device_id;
       end if;
   end if;
     end loop;

--end loop;


--tail :=replace(tail||'*', '|*','');
--p_tail := tail;

clpr_ubi_moro.pp_tail(p_tail => p_tail,
                      p_cant => 5);
end pp_ubi_tecn_clie ;

procedure pp_tail (p_tail out varchar2,
                   p_cant in number)is
   tail   varchar2(32000);
  cursor mapa is
  select * 
    from ( select 
           c006 device_name,
           c008 lastvalidlatitude,
           c009 lastvalidlongitude
            from apex_collections a
           where collection_name = 'CLIE_MOROSOS'
             and c008 is not null 
             and c020 = 1
           order by to_number(c018))
            WHERE ROWNUM <= p_cant;
begin



  for k in mapa loop
    tail:=tail||k.lastvalidlatitude|| ',' ||k.lastvalidlongitude|| ','||substr(k.device_name, 1, 100)|| '|';
  end loop;
  
  tail :=replace(tail||'*', '|*','');
  p_tail := tail;

end pp_tail;


procedure pp_generar_ot(p_seq_id in number,
                        p_tecnico in number) is

  v_codigo        number;
  v_motivo        varchar2(200);
  v_numero        number;
  v_vehi_codi     number;
  v_deta_codi     number;
  v_palele_number varchar2(200);
  v_cant_fact     number;
  v_cliente       number;
  v_ortr_codi     number;
  v_ortr_nume     number;
  v_user          varchar2(20) :=fp_user;
  v_sose_codi     number;
  v_tele_part     varchar2(200);
  v_ciud_codi     number;
  v_ubicacion     varchar2(200);
  v_user_codi     number;
  v_cnt_codigo    varchar2(1000) := crm_neg_ticket_seq.nextval;
  v_hora          varchar2(1000);
  v_count_desi    number :=0;
  v_count_desi_p  number :=0;
  v_ot            number := 0;
  v_dispositivo number;
begin
 ---raise_application_error(-20001,v_hora);
  select c016 plate_number, c029 cant_venc, c024 cliente, c030, c001
    into v_palele_number, v_cant_fact, v_cliente, v_hora, v_dispositivo
    from apex_collections a
   where collection_name = 'CLIE_MOROSOS'
     and seq_id= p_seq_id;
  if v_cliente is null then
    raise_application_error(-20001,
                            'No se encuentra el codigo del cliente');
  end if;

  begin
    select vehi_codi, deta_codi, anex_sose_codi, sose_tele_part, sose_ciud_codi, sose_ubicacion
      into v_vehi_codi, v_deta_codi, v_sose_codi,  v_tele_part,v_ciud_codi, v_ubicacion
      from come_vehi, come_soli_serv_anex_deta,come_soli_serv_anex ,come_soli_serv_clie_dato
     where deta_anex_codi = anex_codi
       and anex_sose_codi = sose_Codi
       and deta_vehi_codi = vehi_codi
       and nvl(deta_esta, vehi_esta) = 'I'
       and nvl(vehi_esta_vehi, 'A') <> 'I'
       and vehi_clpr_codi = v_cliente
       and vehi_nume_pate = v_palele_number;
  exception
    when no_data_found then
      raise_application_error(-20001, 'No se encuentra el movil');
  end;

   select count(*)
        into v_count_desi_p
        from come_soli_desi, come_orde_trab t 
       where sode_vehi_codi = v_vehi_codi
       and sode_codi = t.ortr_sode_codi
         and nvl(ortr_esta,'P') in ('P');
  
  if v_count_desi_p > 0 then       
   -----------si tiene solicitudes en estado pendiente o autorizado se cambia a rechazado y se elimina la ot      
    
   for x in (select e.sode_vehi_codi, e.sode_deta_codi, e.sode_codi
              from come_soli_desi e
             where sode_vehi_codi = v_vehi_codi
               and sode_esta in ('P' ,'A')) loop
         
   
   
         select ortr_codi
         into v_ot
         from come_orde_trab 
         where ortr_sode_codi =x.sode_codi;
         
         delete from come_orde_trab_vehi 
         where vehi_ortr_codi = v_ot;
          
         delete from come_orde_trab 
         where ortr_codi =v_ot;
         
         update come_soli_desi
            set sode_esta = 'R'
          where sode_codi = x.sode_codi;
         
    
   end loop;
   
 end if;         
  
 --------------------------------validamos si el vehiculo ya tiene usa solicitud de desistalacion liquidada
  
     select count(*)
        into v_count_desi
        from come_soli_desi, come_orde_trab t
       where sode_vehi_codi = v_vehi_codi
         and sode_codi = t.ortr_sode_codi
         and ortr_esta = 'L';
   -- raise_application_error(-20001,v_vehi_codi);
      if v_count_desi > 0 then
        raise_application_error(-20001,'El vehiculo seleccionada ya esta ralacionada con una solicitud de desistalacion liquidada');
      end if;








  select nvl(max(sode_codi), 0) + 1 into v_codigo from come_soli_desi;

  i020286_a.pp_genera_nume(v_numero);

   v_motivo := 'Moroso ' || v_cant_fact ||' Facturas';
  

    -----------se carga y autoriza la solicitud
    insert into come_soli_desi
      (sode_codi,
       sode_nume,
       sode_empr_codi,
       sode_anex_codi,
       sode_deta_nume_item,
       sode_fech_emis,
       sode_user_regi,
       sode_fech_regi,
       sode_clpr_codi,
       sode_sucu_nume_item,
       sode_clve_iden,
       sode_esta,
       sode_vehi_codi,
       sode_moti,
       sode_tipo_moti,
       sode_deta_codi,
       sode_sopr_codi,
       sode_base)
    values
      (v_codigo,
       v_numero,
       parameter.p_empr_codi,
       null,
       null,
       trunc(sysdate),
       v_user,
       sysdate,
       v_cliente,
       null,
       null,
       'A',
       v_vehi_codi,
       v_motivo,
       'E',
       v_deta_codi,
       null,
       parameter.p_codi_base);
       
       
  ------------------generamos la ot 
        v_ortr_codi := fa_sec_come_orde_trab;
        begin
          select nvl(max(to_number(ortr_nume)), 0) + 1
            into v_ortr_nume
            from come_orde_trab;
        end;
      
        -- inserta la OT
        insert into come_orde_trab
          (ortr_codi,
           ortr_clpr_codi,
           ortr_nume,
           ortr_fech_emis,
           ortr_fech_grab,
           ortr_user,
           ortr_esta,
           ortr_desc,
           ortr_base,
           ortr_sucu_codi,
           ortr_mone_codi_prec,
           ortr_prec_vent,
           ortr_tipo_cost_tran,
           ortr_serv_tipo,
           ortr_serv_tipo_moti,
           ortr_serv_cate,
           ortr_serv_dato,
           ortr_user_regi,
           ortr_fech_regi,
           ortr_clpr_sucu_nume_item,
           ortr_sode_codi,
           ortr_vehi_codi,
           ortr_cant,
           ortr_deta_codi)
        values
          (v_ortr_codi,
           v_cliente,
           v_ortr_nume,
           to_date(sysdate, 'dd-mm-yyyy'),
           sysdate,
           v_user,
           'P',
           'Desinstalacion',
           1,
           1,
           1,
           0,
           1,
           'D',
           'E',
           'P',
           'K',
           v_user,
           sysdate,
           null,
           v_codigo,
           v_vehi_codi,
           null,
           v_deta_codi);
      insert into come_orde_trab_vehi    
              (vehi_ortr_codi,
               vehi_nume_item,
               vehi_empl_codi,
               vehi_pola,
               vehi_leva_vidr_elec,
               vehi_retr_elec,
               vehi_limp_para_dela,
               vehi_limp_para_tras,
               vehi_tanq,
               vehi_dire_hidr,
               vehi_auto_radi,
               vehi_ante_elec,
               vehi_aire_acon,
               vehi_bloq_cent,
               vehi_abag,
               vehi_fabs,
               vehi_tapi,
               vehi_alar,
               vehi_boci,
               vehi_lava_faro,
               vehi_llan,
               vehi_cubi,
               vehi_comb,
               vehi_cent,
               vehi_chap,
               vehi_pint,
               vehi_lalt,
               vehi_lbaj,
               vehi_lrev,
               vehi_lgir,
               vehi_lpos,
               vehi_lint,
               vehi_lsto,
               vehi_lest,
               vehi_ltab,
               vehi_user_regi,
               vehi_fech_regi)
            values
                 (v_ortr_codi,
                  1,
                  p_tecnico,
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   'N',
                   v_user,
                   sysdate);
            
  
  -----------------generamos el ticket de desistalacion 
  
        select user_codi 
          into v_user_codi 
          from segu_user 
         where user_login = v_user;


  insert into crm_neg_ticket
       (ctn_codi,
        ctn_tickt_embu,
        ctn_etap_codi,
        ctn_observacion,
        ctn_tecnico,
        ctn_recurso,
        ctn_fech_prev,
        ctn_hora_prev,
        ctn_user_codi,
        ctn_fech_ini,
        ctn_user_reg,
        ctn_fech_grab,
        
        ----------------soli
        ctn_sose_codi,
        ctn_tipo_serv,
        ctn_ortr_codi,
        ctn_vehi_codi,
        --------------clie
        ctn_clpr_codi,
        ctn_ciudad,
        ctn_telef,
        ctn_ubicacion)
values (v_cnt_codigo,
        1,
        5,
        v_motivo,
        p_tecnico,
        8,---tecnico desistalador
        trunc(sysdate),
        v_hora,--v_ctn_hora_prev,
        v_user_codi,
        trunc(sysdate),
        v_user,
        sysdate,
        
        ----------------soli
        v_sose_codi,
        'D',
        v_ortr_codi,
        v_vehi_codi,
        --------------clie
        v_cliente,
        v_ciud_codi,
        v_tele_part,
        v_ubicacion);
        
          update mapa_ubic_clie_moro a
            set clim_nego_codi = v_cnt_codigo,
                clim_orde_codi = v_ortr_codi
          where a.clim_cliente = v_cliente
            and  clim_dispo = v_dispositivo ;
         
          
          
end pp_generar_ot;

procedure pp_editar_hora(p_seq_id in varchar2,
                         p_valor  in varchar2)is 

 v_indica varchar2(20);
 v_saldo number;
 v_seq_id varchar2(20);
 begin
  v_seq_id := replace(p_seq_id,'f01_');

                             
APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'CLIE_MOROSOS',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 30,
                                          P_ATTR_VALUE      => p_valor);


   --raise_application_error(-20001,p_valor||'--'||v_seq_id);
end pp_editar_hora;



procedure pp_guardar_buzon (p_nego_codi in number,
                            p_cliente   in number,
                            p_resultado in number,
                            p_fecha     in date,
                            p_obse      in varchar2) is
  
begin

  gene_llam_deta.pa_gene_llam_deta(p_cliente,
                                   p_resultado,
                                   4,
                                    to_date(p_fecha, 'DD/MM/YYYY'),
                                    to_date(p_fecha, 'DD/MM/YYYY'),
                                    p_obse,
                                    null, 
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    p_nego_codi);
                                    
                                    
                                    
       update crm_neg_ticket
          set ctn_etap_codi = 3,
              ctn_tecnico = null
        where ctn_codi = p_nego_codi;
                           
                                     
                                    
end pp_guardar_buzon;



procedure pp_revi_clie_sald is 
  cursor cliente is
      select t.clim_cliente,
             t.clim_orde_codi,
             t.clim_nego_codi
      from mapa_ubic_clie_moro t
      where clim_orde_codi is not null ;
      
   v_movi_fech_emis date;   
      
 begin
   
 
  for x in cliente loop
  
          select max(movi_fech_emis)
           into v_movi_fech_emis
                  from come_movi
                 where movi_clpr_codi = x.clim_cliente
                   and movi_timo_codi = 13;
                   
      if v_movi_fech_emis is not null then
        
       if v_movi_fech_emis between trunc(sysdate)-30 and trunc(sysdate) then
        update crm_neg_ticket
          set ctn_etap_codi = 9,
              ctn_tecnico = null
        where ctn_codi = x.clim_nego_codi;
       
       end if;
       
         delete from come_orde_trab_vehi 
         where vehi_ortr_codi = x.clim_orde_codi;
          
         delete from come_orde_trab 
         where ortr_codi =x.clim_orde_codi;
       
      
      end if;           
                   
end loop;                  
                  
end pp_revi_clie_sald ;

end clpr_ubi_moro;
