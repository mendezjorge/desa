
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020400" is




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
                 deta_camb_id_file
      from come_soli_camb_plan_deta
   where deta_camb_plan_codi =p_camb_soli;

  v_user          varchar2(100):= GEN_USER;
  v_nro_solicitud number;
  v_nro_anexo     number;
  v_concepto      varchar2(1000);
  v_vehiculo      varchar2(1000);
  v_tipo          varchar2(1000);
  begin


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
                                 p_c020           => v_tipo
                                 );

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
  procedure pp_agregar_deta(p_camb_soli in number,
                            p_cliente   in number,
                            p_solicitud in number,
                            p_anexo     in number,
                            p_anex_deta in number,
                            p_precio    in number,
                            p_obse      in varchar2,
                            p_img       in varchar2) is



  v_archivo       blob;
  v_mime_type     varchar2(2000);
  v_filename      varchar2(2000);
  v_existe        number;
  v_nro_solicitud number;
  v_nro_anexo     number;
  v_concepto      varchar2(1000);
  v_vehiculo      varchar2(1000);
   v_tipo          varchar2(1000);
  begin

        if p_cliente   is null then
          raise_application_error(-20001,'Debe elegir un cliente');
        end if;
        if p_solicitud is null then
          raise_application_error(-20001,'Debe elegir la solicitud');
        end if;
        if p_anexo     is null then
          raise_application_error(-20001,'Debe elegir el anexo');
        end if;
        if p_anex_deta is null then
          raise_application_error(-20001,'Debe elegir el detalle del anexo');
        end if;
        if p_precio    is null then
          raise_application_error(-20001,'Debe cargar el precio ');
        end if;
        if p_obse      is null then
          raise_application_error(-20001,'Debe agregar la observacion ');
        end if;
        if p_img       is null then
          raise_application_error(-20001,'Debe cargar el documento de prueba');
        end if;
  --  raise_application_error(-20001, p_img);
  -------obtener imagen
      begin
        SELECT blob_content, mime_type, filename
          INTO v_archivo, v_mime_type, v_filename
          FROM APEX_APPLICATION_FILES A
         WHERE A.NAME = p_img
           AND ROWNUM = 1;
      exception
        when others then
          null;
      end;

       select count(seq_id)
         into v_existe
         from apex_collections a
        where collection_name = 'DETALLE'
          and nvl(c015,'N') ='N'
          and c003 = p_anexo
          and c004 = p_anex_deta;
       if v_existe > 0 then
         raise_application_error(-20001,
                                 'Ya existe un registe con el mismo anexo y detalle cargado previamente');
       end if;


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
       and c.deta_anex_codi = p_anexo
       and c.deta_codi = p_anex_deta;


    apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001           => p_camb_soli,
                                 p_c002           => p_solicitud,
                                 p_c003           => p_anexo,
                                 p_c004           => p_anex_deta,
                                 p_c005           => null,
                                 p_c006           => p_precio,
                                 p_c007           => p_obse,
                                 p_c008           => 'P',
                                 p_C009           => v_filename,
                                 p_C010           => v_mime_type,
                                 p_c011           => p_cliente,
                                 p_BLOB001        => v_archivo,
                                 p_c016           => v_nro_solicitud,
                                 p_c017           => v_nro_anexo,
                                 p_c018           => v_concepto,
                                 p_c019          => v_vehiculo,
                                 p_c020          => v_tipo
                                 );





      delete temp_imagen
     where login = gen_user
       and session_id = v('app_session')
       and img_id = (select max(seq_id)
                      from apex_collections a
                     where collection_name = 'DETALLE');


 insert into temp_imagen
  (img_id, cont_bloc, login, session_id, id_imagen, file_name, mime_type,fecha_actualizacion)
values
  ((select max(seq_id)
  from apex_collections a
 where collection_name = 'DETALLE') , v_archivo, GEN_USER, V('APP_SESSION'), null, v_filename, v_mime_type,sysdate);

  end pp_agregar_deta;


 procedure pp_validaciones is
   v_cant_deta number;
 begin
          select count(seq_id)
            into v_cant_deta
            from apex_collections a
           where collection_name = 'DETALLE';

 if v_cant_deta <=0 then
   raise_application_error(-20001, 'Debe cargar por lo menos un detalle');
 end if;
--   v_cant_deta

 end pp_validaciones;

procedure pp_actu_deta (p_cliente   in number,
                        p_soli_camb in number) is

cursor anex is
          select c001    camb_soli,
                 c002    solicitud,
                 c003    anexo,
                 c004    nro_anexo,
                 c005    precio_ant,
                 c006    precio,
                 c007    observacion,
                 c008    estado,
                 C009    filename,
                 C010    mime_type,
                 BLOB001 archivo,
                 seq_id  img_id,
                 nvl(c015,'N')    eliminar
            from apex_collections a
           where collection_name = 'DETALLE'
             and nvl(c008,'P') = 'P'
             order by 12;



 v_user  varchar2(60):= gen_user;
 v_prec_unit number;


begin

for x in anex loop


  delete come_soli_camb_plan_deta
     where deta_camb_plan_codi = p_soli_camb
       and deta_camb_anex =  x.anexo
       and deta_camb_anex_deta = x.nro_anexo;

     if x.eliminar  = 'N' then


      select deta_prec_unit
        into v_prec_unit
        from come_soli_serv_anex_deta t
       where t.deta_anex_codi =x.anexo
         and t.deta_codi = x.nro_anexo;
     insert into come_soli_camb_plan_deta
        (deta_camb_plan_codi,
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
         deta_camb_apli)
      values
        (p_soli_camb,
         x.solicitud,
         x.anexo,
         x.nro_anexo,
         NULL,--v_deta_camb_impo_ante,
         x.precio,
         x.observacion,
         x.archivo,
         x.estado,
         v_user,
         sysdate,
         X.mime_type,
         X.filename,
         X.img_id,
         'N');
   end if;

end loop;

end pp_actu_deta;

procedure pp_actualizar_registro(p_camb_clave in number,
                                 p_cliente    in number) is

  v_user varchar2(60) := gen_user;
  v_clave NUMBER;
  v_Cant_cuotas number;
begin


    pp_validaciones;



 I020400.pp_cant_cuot_venc(p_cliente => p_cliente, p_cuotas => v_Cant_cuotas);

if v_Cant_cuotas >2 then
  raise_application_error(-20001, 'El cliente cuenta con mas de dos cuotas vencidas');
end if;

 if p_camb_clave is null then



  select seq_camb_plan_impo.nextval into v_clave from dual;
  insert into come_soli_camb_plan
    (camb_plan_codigo,
     camb_plan_clpr,
     camb_plan_esta,
     camb_plan_user_grab,
     camb_plan_fech_grab,
     camb_plan_user_modi,
     camb_plan_fech_modi)
  values
    (v_clave,
     p_cliente,
     'P',
     v_user,
     sysdate,
     null,
     null);
 else
  v_clave := p_camb_clave;
 update come_soli_camb_plan
    set camb_plan_user_modi = v_user,
        camb_plan_fech_modi = sysdate
  where camb_plan_codigo = v_clave;


 end if;
          pp_actu_deta (p_cliente   => p_cliente,
                        p_soli_camb => v_clave);

 pp_actualizar (v_clave);

end pp_actualizar_registro;

procedure pp_borrar_registro( p_clave in number)is
  v_cant number;
begin


select count(deta_camb_esta)
 into v_cant
  from come_soli_camb_plan_deta
 where nvl(deta_camb_esta,'P') <> 'P'
   and deta_camb_plan_codi = p_clave;


 if v_cant >0 then
    raise_application_error(-20001,'Ya no se puede eliminar el registro, porque existen detalles aprobados');
 end if;


 delete come_soli_camb_plan_deta
  where deta_camb_plan_codi = p_clave;

 delete come_soli_camb_plan
  where camb_plan_codigo = p_clave;


end pp_borrar_registro;


procedure pp_cant_cuot_venc (p_cliente in number,
                             p_cuotas  out number) is

begin

 select max(cant_cuot_venc)
   into p_cuotas
   from come_temp_cuot_pend_v t
  where clpr_codi = p_cliente;
exception when no_data_found then

p_cuotas := 0;

end pp_cant_cuot_venc;

procedure pp_actualizar (p_camb_codi in number)is

cursor cambi is
select t.deta_camb_plan_codi camb_soli,
       t.deta_camb_soli solicitud,
       t.deta_camb_anex anexo,
       t.deta_camb_anex_deta nro_anexo,
       t.deta_camb_impo_nuev  nuevo_importe,
       'A' estado,
       null seq_id
from come_soli_camb_plan_deta t
where t.deta_camb_plan_codi = p_camb_codi;
/*  select c001    camb_soli,
         c002    solicitud,
         c003    anexo,
         c004    nro_anexo,
         c008    estado,
         seq_id,
         c006    nuevo_importe
     from apex_collections a
    where collection_name = 'DETALLE'
      and c021 = 'N'
      and c008 <> 'P';*/

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

end I020400;
