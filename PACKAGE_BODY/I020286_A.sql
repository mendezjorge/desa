
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020286_A" is

  type r_parameter is record(
    p_usuario varchar2(100) := fa_user,
    --p_codi_base number       := pack_repl.fa_devu_codi_base;
    p_indi_most_mens_sali varchar2(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_most_mens_sali')))),
    p_indi_nota_canc_desi varchar2(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_nota_canc_desi')))),
    
    p_empr_codi number := 1);
  parameter r_parameter;

  /*procedure pp_veri_sode_grua(p_sode_nume      in number,
                              p_sode_empr_codi number) is
    v_cant number;
  begin
    begin
      select count(*)
        into v_cant
        from come_soli_desi
       where sode_nume = p_sode_nume
         and nvl(sode_tipo_moti, 'o') = 'g'
         and sode_empr_codi = p_sode_empr_codi;
    end;
  
    if v_cant > 0 then
      raise_application_error(-20001,
                              'esta solicitud corresponde a desinstalaci?n de gr?a, verifique en el programa correspondiente.');
    end if;
  
  end pp_veri_sode_grua;*/

  procedure pp_validar_sub_cuenta(p_sode_clpr_codi    in number,
                                  p_indi_vali_subc out varchar2) is
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_sode_clpr_codi;
  
    if v_count > 0 then
      p_indi_vali_subc := 'S';
      --:babmc.s_indi_vali_subc := 's';
      -- set_item_property('babmc.sode_sucu_nume_item', enabled, property_true);
      --  set_item_property('babmc.sode_sucu_nume_item', navigable, property_true);
    else
    
      --  :babmc.sode_sucu_nume_item := null;
      --   :babmc.s_sucu_desc := null;
      --  :babmc.s_indi_vali_subc := 'n';
      --  set_item_property('babmc.sode_sucu_nume_item', enabled, property_false);
      p_indi_vali_subc := 'N';
    end if;
  end pp_validar_sub_cuenta;

  procedure pp_muestra_clie_alte(p_clpr_codi_alte in number,
                                 p_clpr_desc      out varchar2,
                                 p_clpr_codi      out number,
                                 p_clpr_clie_clas1_codi out number
                                 ) is
  begin
    select clpr_desc, clpr_codi , clpr_clie_clas1_codi
      into p_clpr_desc, p_clpr_codi, p_clpr_clie_clas1_codi
      from come_clie_prov
     where clpr_codi_alte = p_clpr_codi_alte
       and clpr_indi_clie_prov = 'C';
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      p_clpr_codi := null;
      raise_application_error(-20001, 'Cliente Inexistente');
    when others then
      raise_application_error(-20001, 'Error- ' || sqlerrm);
  end pp_muestra_clie_alte;

  procedure pp_muestra_clie(p_clpr_codi      in number,
                            p_clpr_desc      out varchar2,
                            p_clpr_codi_alte out number,
                            p_clpr_clie_clas1_codi out number
                            ) is
  begin
    select clpr_desc, clpr_codi_alte , clpr_clie_clas1_codi
      into p_clpr_desc, p_clpr_codi_alte , p_clpr_clie_clas1_codi
      from come_clie_prov
     where clpr_codi = p_clpr_codi
       and clpr_indi_clie_prov = 'C';
  
  exception
    when no_data_found then
      --p_clpr_desc := null;
    --  p_clpr_codi := null;
      raise_application_error(-20001, 'Cliente Inexistente');
    when others then
      raise_application_error(-20001, 'Error- ' || sqlerrm);
  end pp_muestra_clie;

procedure pp_muestra_come_clpr_sub_cuen(p_clpr_codi in number, 
                                        p_sucu_nume_item  in number, 
                                        p_sucu_desc out char/*, 
                                        p_sucu_tele out char*/
                                        ) is
begin
  select sucu_desc--, sucu_tele
    into p_sucu_desc--, p_sucu_tele
    from come_clpr_sub_cuen
   where sucu_clpr_codi = p_clpr_codi
     and sucu_nume_item = p_sucu_nume_item;
  
exception
  when no_data_found then
 
raise_application_error(-20001,'Subcuenta Inexistente!');
  when others then
     raise_application_error(-20001,'Error- '||sqlerrm);
end pp_muestra_come_clpr_sub_cuen;

procedure pp_valida_vehi (p_deta_iden in varchar2, 
                          p_vehi_codi out varchar2,
                          p_sode_codi in number,
                          p_sode_clpr_codi in number,
                          p_sode_sucu_nume_item in number,
                          p_vehi_nume_pate out varchar2,
                          p_mave_desc out varchar2,
                          p_vehi_mode out varchar2,
                          p_sode_deta_codi out varchar2,
                          p_sode_sopr_codi out varchar2) is

  v_vehi_codi varchar2(300);
  v_clpr_codi varchar2(300);
  v_count number;
  v_deta_esta varchar2(300);
  v_vehi_esta_vehi varchar2(300);
  v_deta_codi      varchar2(300);
 v_sopr_codi varchar2(300);
  
begin

  select vehi_codi,
         vehi_clpr_codi,
         nvl(deta_esta, vehi_esta) deta_esta,
         vehi_esta_vehi,
         deta_codi,
         vehi_nume_pate,
         mave_desc,
         vehi_mode
    into v_vehi_codi,
         v_clpr_codi,
         v_deta_esta,
         v_vehi_esta_vehi,
         v_deta_codi,
         p_vehi_nume_pate,
         p_mave_desc,
         p_vehi_mode
    from come_marc_vehi,
         come_vehi,
         come_soli_serv_anex_deta
   where deta_vehi_codi = vehi_codi
     and vehi_mave_codi = mave_codi(+)
     and nvl(deta_esta, vehi_esta) = 'I'
     and nvl(vehi_esta_vehi, 'A') <> 'I'
     and (vehi_clpr_codi = p_sode_clpr_codi or p_sode_clpr_codi is null)
     and (vehi_clpr_sucu_nume_item = p_sode_sucu_nume_item or p_sode_sucu_nume_item is null)
     and nvl(deta_iden, vehi_iden) = p_deta_iden;

    begin
      select count(*)
        into v_count
        from come_soli_desi
       where sode_vehi_codi = v_vehi_codi
         and (sode_codi <> p_sode_codi or p_sode_codi is null)
         and sode_esta = 'P';
    
      if v_count > 0 then
        raise_application_error(-20001,'El veh?culo seleccionado ya est? relacionado a una solicitud de desinstalaci?n.');
      end if;
    end;
    
    begin
      select count(*)
        into v_count
        from come_soli_prev_desi
       where sopr_vehi_codi = v_vehi_codi
         and sopr_esta != 'L';
    
      if v_count > 0 then
        raise_application_error(-20001,'El veh?culo seleccionado est? relacionado en una solicitud de vehiculos a desinstalar sin liquidar.');
      end if;
    end;
    
    /*as
    begin
      select sopr_codi
        into v_sopr_codi
        from come_soli_prev_desi
       where sopr_vehi_codi = v_vehi_codi
         and sopr_esta = 'l';
    end;
    */
  
    --if :babmc.w_indi_oper = 'i' then
      if v_clpr_codi <> p_sode_clpr_codi then
        raise_application_error(-20001,'El vehiculo no pertenece al Cliente seleccionado.');
      end if;
      if v_deta_esta <> 'I' then
        raise_application_error(-20001,'El veh?culo debe estar instalado!');
      end if;
      if v_vehi_esta_vehi = 'I' then
        raise_application_error(-20001,'El veh?culo esta Inactivo.');
      end if;
       -- end if;
    
      p_vehi_codi           :=v_vehi_codi;
       p_sode_deta_codi := v_deta_codi;
       p_sode_sopr_codi := v_sopr_codi;
     
exception
  when no_data_found then
    raise_application_error(-20001,'Vehiculo inexistente.');     
end pp_valida_vehi;




procedure pp_muestra_vehi(p_vehi_codi in number, 
                          p_nume_pate out char, 
                          p_mave_desc out char, 
                          p_deta_mode out char, 
                          p_vehi_iden out char) is
begin
  select vehi_nume_pate, mave_desc, vehi_mode, vehi_iden
    into p_nume_pate, p_mave_desc, p_deta_mode, p_vehi_iden
    from come_vehi,
         come_marc_vehi
   where vehi_mave_codi = mave_codi
     and vehi_codi = p_vehi_codi;
 --    raise_application_error(-20001,'holaaaaa '||length(p_vehi_iden));
 exception
   when no_data_found then
     raise_application_error(-20001,'Vehiculo Inexistente');     
   when others then
     raise_application_error(-20001,'Error- '||sqlerrm);
    --raise_application_error(-20001,'holaaaaa '||length(p_vehi_iden));
end pp_muestra_vehi;


procedure pp_mostrar_tipo_vehi_alte(p_tive_codi_alte in char,
                                    p_tive_desc out varchar2,
                                    p_tive_codi out number) is
begin
  select tive_desc, tive_codi
    into p_tive_desc, p_tive_codi
    from come_tipo_vehi
   where  rtrim(ltrim(tive_codi_alte)) = rtrim(ltrim(p_tive_codi_alte))
     and tive_empr_codi = parameter.p_empr_codi;

exception
  when no_data_found then
    p_tive_desc := null;
    p_tive_codi := null;
    raise_application_error(-20001,'Tipo de Vehiculo Inexistente');    
  when others then
    raise_application_error(-20001,'Error '||sqlerrm);
end pp_mostrar_tipo_vehi_alte;



procedure pp_mostrar_marc_vehi_alte(p_mave_codi_alte in char, 
                                    p_mave_desc out varchar2, 
                                    p_mave_codi out number) is
begin
  select mave_desc, mave_codi
    into p_mave_desc, p_mave_codi
    from come_marc_vehi
   where  rtrim(ltrim(mave_codi_alte)) = rtrim(ltrim(p_mave_codi_alte))
     and mave_empr_codi = parameter.p_empr_codi;

exception
  when no_data_found then
    p_mave_desc := null;
    p_mave_codi := null;
    raise_application_error(-20001,'Marca de Vehiculo Inexistente');     

  when others then
     raise_application_error(-20001,'Error '||sqlerrm);
end pp_mostrar_marc_vehi_alte;



procedure pp_validar_nuevo(p_sode_tipo_moti in varchar2,
                           p_reve_tive_codi in number,
                           p_reve_mave_codi in number,
                           p_reve_mode in varchar2,
                           p_reve_anho in varchar2,
                           p_reve_colo in varchar2,
                           p_reve_nume_chas in varchar2,
                           p_reve_nume_pate in varchar2) is
 begin
 if nvl(p_sode_tipo_moti, 'x') = 'RN' then
  if p_reve_tive_codi is null then
    raise_application_error(-20001,'Debe ingresar codigo de Tipo Vehiculo.');
  end if;
  if p_reve_mave_codi is null then
    raise_application_error(-20001,'Debe asignar la Marca del vehiculo.');
  end if;
  if p_reve_mode is null then
   raise_application_error(-20001,'Debe asignar el Modelo del vehiculo.');
  end if;
  if p_reve_anho is null then
    raise_application_error(-20001,'Debe asignar el A?o del vehiculo.');
  end if;
  if p_reve_colo is null then
    raise_application_error(-20001,'Debe asignar el Color del vehiculo.');
  end if;
  if p_reve_nume_chas is null then
    raise_application_error(-20001,'Debe asignar el Nro de Chasis del vehiculo.');
  end if;
  if p_reve_nume_pate is null then
    raise_application_error(-20001,'Debe asignar el Patente del vehiculo.');
 end if;
end if;
end pp_validar_nuevo;





procedure pp_mostrar_new_vehi(p_reve_codi out number,
                              p_reve_sode_codi in number,
                              p_reve_tive_codi out number,
                              p_reve_mave_codi out number,
                              p_reve_mode out varchar2,
                              p_reve_anho out varchar2,
                              p_reve_colo out varchar2,
                              p_reve_nume_chas out varchar2,
                              p_reve_nume_pate out varchar2,
                              p_reve_vehi_codi out number,
                              p_reve_base out varchar2,
                              p_reve_user_regi out varchar2,
                              p_reve_fech_regi out varchar2,
                              p_reve_user_modi out varchar2,
                              p_reve_fech_modi out varchar2) is
  begin
    select f.reve_codi,
       f.reve_tive_codi,
       f.reve_mave_codi,
       f.reve_mode,
       f.reve_anho,
       f.reve_colo,
       f.reve_nume_chas,
       f.reve_nume_pate,
       f.reve_vehi_codi,
       f.reve_base,
       f.reve_user_regi,
       f.reve_fech_regi,
       f.reve_user_modi,
       f.reve_fech_modi
       into  
        p_reve_codi,
        p_reve_tive_codi,
        p_reve_mave_codi,
        p_reve_mode,
        p_reve_anho,
        p_reve_colo,
        p_reve_nume_chas,
        p_reve_nume_pate,
        p_reve_vehi_codi,
        p_reve_base,
        p_reve_user_regi,
        p_reve_fech_regi,
        p_reve_user_modi,
        p_reve_fech_modi
      from come_rein_inst_vehi f
      where f.reve_sode_codi=p_reve_sode_codi;
     exception when no_data_found then
       null;
       when others then
       raise_application_error(-20001,'Error '||sqlerrm);
    end pp_mostrar_new_vehi;



procedure pp_mostrar_tipo_vehi(p_tive_codi in number, 
                               p_tive_desc out varchar2) is
begin
  select tive_desc
    into p_tive_desc
    from come_tipo_vehi
   where tive_codi = p_tive_codi;
  
exception
   when no_data_found then
     p_tive_desc := null;
     raise_application_error (-20001,'Tipo de Vehiculo Inexistente.');    

   when others then
   raise_application_error(-20001,'Error '||sqlerrm);
end pp_mostrar_tipo_vehi;


procedure pp_mostrar_marc_vehi(p_mave_codi in number, 
                               p_mave_desc out varchar2) is
begin
  select mave_desc
    into p_mave_desc
    from come_marc_vehi
   where mave_codi = p_mave_codi;
  
exception
   when no_data_found then
     p_mave_desc := null;
     raise_application_error (-20001,'Marca de Vehiculo Inexistente');    
   when others then
      raise_application_error(-20001,'Error '||sqlerrm);
end pp_mostrar_marc_vehi;



procedure pp_borrar_nuevo_vehi(p_reve_codi in number) is
  v_reve_vehi_codi number(20);
begin

      begin
        select r.reve_vehi_codi
          into v_reve_vehi_codi
          from come_rein_inst_vehi r
         where r.reve_codi = p_reve_codi;
      exception
        when others then
          v_reve_vehi_codi := null;
      end;
    
      if v_reve_vehi_codi is not null then
        raise_application_error(-20001,'No se puede borrar el registro. Ya se gener? un veh?culo con esos datos');
      else
      
        raise_application_error(-20001,'Recuerde presionar el bot?n Aceptar del formulario para que el borrado sea confirmado');
      end if;  
end pp_borrar_nuevo_vehi;


procedure pp_veri_ot_sode(p_sode_codi in number,
                          p_mensaje out varchar2) is

v_ortr_nume         number;
v_ortr_desc         varchar2(500);
v_ortr_codi_padr    number;

begin
  
  select ortr_nume, ortr_desc, ortr_codi_padr
    into v_ortr_nume, v_ortr_desc, v_ortr_codi_padr
    from come_orde_trab t
   where ortr_sode_codi = p_sode_codi;
      
      if v_ortr_codi_padr is not null then
        p_mensaje:='No se podr?n realizar cambios a la Solicitud, porque fue generada desde la OT '||v_ortr_nume||' por '||v_ortr_desc;
      end if;


exception     
  when no_data_found then
    null;       
end pp_veri_ot_sode;




procedure pp_genera_nume(p_sode_nume out number) is
begin
  select nvl(max(sode_nume), 0) + 1
    into p_sode_nume
    from come_soli_desi
   where sode_empr_codi = parameter.p_empr_codi;
  
exception
  when others then
		null;
end pp_genera_nume;

procedure pp_actualizar_registro(p_sode_empr_codi in number,
                                 p_sode_anex_codi in number,
                                 p_sode_deta_nume_item in number,
                                 p_sode_fech_emis varchar2,
                                 p_sode_vehi_codi in number,
                                 p_sode_clpr_codi in number,
                                 p_sode_sucu_nume_item in number,
                                 p_sode_clve_iden in varchar2,
                                 p_sode_moti in varchar2,
                                 p_sode_tipo_moti in varchar2,
                                 p_sode_deta_codi in number,
                                 p_sode_sopr_codi in number,
                                 p_clpr_clie_clas1_codi in number,
                                 p_clpr_desc in varchar2,
                                 p_opcion in varchar2,
                                 p_sode_codi in number,
                                 p_reve_tive_codi in number,
                                 p_reve_mave_codi in number,
                                 p_reve_mode      in varchar2,
                                 p_reve_anho      in varchar2,
                                 p_reve_colo      in varchar2,
                                 p_reve_nume_chas in varchar2,
                                 p_reve_nume_pate in varchar2,
                                 p_reve_vehi_codi in number,
                                 p_reve_codi      in number,
                                 p_sode_estado in varchar2)
  is
  v_codigo number;
  v_estado varchar2(20);
  v_numero number;
  begin
    -----

   select nvl(max(sode_codi), 0) + 1
	  into v_codigo
	  from come_soli_desi;
    -----
  
   i020286_a.pp_genera_nume(v_numero);


if p_clpr_clie_clas1_codi = 3 then
	v_estado := 'A';
else
	v_estado := 'P';
end if;


  
if p_opcion='I' then     

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
   sode_sopr_codi)
values
  (v_codigo,
   v_numero,
   p_sode_empr_codi,
   p_sode_anex_codi,
   p_sode_deta_nume_item,
   p_sode_fech_emis,
   fa_user,
   sysdate,
   p_sode_clpr_codi,
   p_sode_sucu_nume_item,
   p_sode_clve_iden,
   v_estado,
   p_sode_vehi_codi,
   p_sode_moti,
   p_sode_tipo_moti,
   p_sode_deta_codi,
   p_sode_sopr_codi);
   
   

   begin
   -- call the procedure
   i020286_a.pp_generar_ot(p_clpr_desc => p_clpr_desc,
                          p_sode_fech_emis => p_sode_fech_emis,
                          p_sode_nume => v_numero,
                          p_sode_codi => v_codigo,
                          p_sode_clpr_codi => p_sode_clpr_codi,
                          p_sode_tipo_moti => p_sode_tipo_moti,
                          p_sode_sucu_nume_item => p_sode_sucu_nume_item,
                          p_sode_vehi_codi => p_sode_vehi_codi,
                          p_sode_deta_codi => p_sode_deta_codi,
                          p_sode_esta => v_estado);
   end;
   
   else
  update come_soli_desi
   set  sode_anex_codi = p_sode_anex_codi,
        sode_deta_nume_item = p_sode_deta_nume_item,
        sode_user_modi = fa_user,
        sode_fech_modi  = sysdate,
        sode_clpr_codi = p_sode_clpr_codi,
        sode_sucu_nume_item = p_sode_sucu_nume_item,
        sode_clve_iden = p_sode_clve_iden,
        sode_esta = p_sode_estado,
        sode_vehi_codi = p_sode_vehi_codi,
        sode_moti = p_sode_moti,
        sode_tipo_moti = p_sode_tipo_moti,
        sode_deta_codi = p_sode_deta_codi,
        sode_sopr_codi = p_sode_sopr_codi
 where sode_codi = p_sode_codi;
 end if;
  
  if nvl(p_sode_tipo_moti, 'x') = 'RN' and nvl(p_sode_estado,v_estado)='P'then
  
  i020286_a.pp_actualizar_nuevo_vehiculo(p_opcion => p_opcion,
                                         p_reve_sode_codi =>nvl(p_sode_codi,v_codigo),
                                         p_reve_tive_codi => p_reve_tive_codi,
                                         p_reve_mave_codi =>p_reve_mave_codi,
                                         p_reve_mode => p_reve_mode,
                                         p_reve_anho =>p_reve_anho,
                                         p_reve_colo => p_reve_colo,
                                         p_reve_nume_chas => p_reve_nume_chas,
                                         p_reve_nume_pate => p_reve_nume_pate,
                                         p_reve_vehi_codi => p_reve_vehi_codi,
                                         p_reve_codi => p_reve_codi);
                                        
  end if;
                                                                            
      apex_application.g_print_success_message := 'Nro. Solicitud :' ||
                                                  v_numero||
                                                  ' ,Actualizado Correctamente';                          
  exception when others then
    raise_application_error(-20001,'Error '||sqlerrm);
  end pp_actualizar_registro;
    
    
procedure pp_generar_ot(p_clpr_desc in varchar2,
                        p_sode_fech_emis in varchar2,
                        p_sode_nume in number,
                        p_sode_codi in number,
                        p_sode_clpr_codi in number,
                        p_sode_tipo_moti in varchar2,
                        p_sode_sucu_nume_item in number,
                        p_sode_vehi_codi in number,
                        p_sode_deta_codi in number,
                        p_sode_esta in varchar2) is
   cursor c_user is
    select us.user_login
      from come_admi_mens m, come_admi_mens_user u, segu_user us
     where m.adme_codi = u.meus_adme_codi
       and u.meus_user_codi = us.user_codi
       and m.adme_procedure = 'PA_GENE_MENS_SOLI_DESI';

  v_ortr_codi           number;
  v_ortr_nume           number;
  v_ortr_fech_emis      date;
  v_ortr_desc           varchar2(100);
begin
 
  
    
    if p_sode_esta = 'P' then
      for x in c_user loop
        insert into come_mens_sist
          (mesi_codi,
           mesi_desc,
           mesi_user_dest,
           mesi_user_envi,
           mesi_fech,
           mesi_indi_leid,
           mesi_tipo_docu,
           mesi_docu_codi)
        values
          (sec_come_mens_sist.nextval,
           ('Se ha generado una nueva solicitud de Desinstalaci?n con Nro. ' ||
            p_sode_nume || ' pare el cliente ' || p_clpr_desc ||
           ', con fecha de emisi?n' || p_sode_fech_emis),
            x.user_login,
            fa_user,
            sysdate,
            'N',
            'SD', --solicitud de desinstalacion
            p_sode_codi);
      end loop;
      
    else
      --si inserta ya autorizado como para aseguradoras
      v_ortr_codi := fa_sec_come_orde_trab;
      
      begin
        select nvl(max(to_number(ortr_nume)), 0) + 1
          into v_ortr_nume
          from come_orde_trab;
      end;
        
      -- inserta la ot
      v_ortr_fech_emis := trunc(sysdate);
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
         p_sode_clpr_codi,
         v_ortr_nume,
         v_ortr_fech_emis,
         sysdate,
         fa_user,
         'P',
         'Desinstalacion',
         1,
         1,
         1,
         0,
         1,
         'D',
         p_sode_tipo_moti,
         'P',
         'K',
         fa_user,
         sysdate,
         p_sode_sucu_nume_item,
         p_sode_codi,
         p_sode_vehi_codi,
         null,
         p_sode_deta_codi);    
    end if;
end pp_generar_ot;

procedure pp_actualizar_nuevo_vehiculo(p_opcion in varchar,
                                       p_reve_sode_codi in number,
                                       p_reve_tive_codi in number,
                                       p_reve_mave_codi in number,
                                       p_reve_mode      in varchar2,
                                       p_reve_anho      in varchar2,
                                       p_reve_colo      in varchar2,
                                       p_reve_nume_chas in varchar2,
                                       p_reve_nume_pate in varchar2,
                                       p_reve_vehi_codi in number,
                                       p_reve_codi in number)
  is
  v_codigo number;
  begin
    


  update come_rein_inst_vehi
      set --reve_sode_codi = p_reve_sode_codi,
       reve_tive_codi = p_reve_tive_codi,
       reve_mave_codi = p_reve_mave_codi,
       reve_mode = p_reve_mode,
       reve_anho = p_reve_anho,
       reve_colo = p_reve_colo,
       reve_nume_chas = p_reve_nume_chas,
       reve_nume_pate = p_reve_nume_pate,
       reve_vehi_codi = p_reve_vehi_codi,
    
       reve_user_modi = fa_user,
       reve_fech_modi = sysdate
 where reve_codi = p_reve_codi
  /*and   reve_sode_codi = p_reve_sode_codi*/;
  
  --RAISE_APPLICATION_ERROR(-20001,p_reve_sode_codi||'aaaaa'||p_reve_codi);
 --RAISE_APPLICATION_ERROR(-20001,p_reve_codi||'MMMM');

 

 if sql%rowcount = 0 and p_reve_codi is null then
   --- obtener un nuevo id
   
    select nvl(max(reve_codi), 0) + 1
    into v_codigo
    from come_rein_inst_vehi;
  
 insert into come_rein_inst_vehi
  (reve_codi,
   reve_sode_codi,
   reve_tive_codi,
   reve_mave_codi,
   reve_mode,
   reve_anho,
   reve_colo,
   reve_nume_chas,
   reve_nume_pate,
   reve_vehi_codi,
   reve_user_regi,
   reve_fech_regi

   )
values
  (v_codigo,
   p_reve_sode_codi,
   p_reve_tive_codi,
   p_reve_mave_codi,
   p_reve_mode,
   p_reve_anho,
   p_reve_colo,
   p_reve_nume_chas,
   p_reve_nume_pate,
   p_reve_vehi_codi,
   fa_user,
   sysdate
   );
   end if;
     
  /*  if gen_user  = 'SKN' THEN
  
  RAISE_APPLICATION_ERROR(-20001,'HOLIS'||p_reve_codi||p_reve_sode_codi);
END IF;*/
  
end pp_actualizar_nuevo_vehiculo;



procedure pp_veri_sode_grua(p_sode_nume in number) is
  v_cant      number;
begin
  begin
    select count(*)
      into v_cant
      from come_soli_desi
     where sode_nume = p_sode_nume
       and nvl(sode_tipo_moti, 'O') = 'G'
       and sode_empr_codi = parameter.p_empr_codi;
  end;
  
  if v_cant > 0 then
    raise_application_error(-20001,'Esta Solicitud corresponde a Desinstalaci?n de Gr?a, verifique en el programa correspondiente.');
  end if;
  
end pp_veri_sode_grua;

procedure pp_valida(p_sode_clpr_codi      in number,
                    p_vehi_iden           in varchar2,
                    p_sode_nume           in number,
                    p_sode_sucu_nume_item in number,
                    p_sode_tipo_moti      in varchar2,
                    p_reve_tive_codi      in number,
                    p_reve_mave_codi      in number,
                    p_reve_mode           in varchar2,
                    p_reve_anho           in varchar2,
                    p_reve_colo           in varchar2,
                    p_reve_nume_chas      in varchar2,
                    p_reve_nume_pate      in varchar2,
                    p_sode_moti           in varchar2,
                    p_sode_fech_emis      in varchar2,
                    p_sode_vehi_codi      in varchar2,
                    p_sode_codi           in number) is

  v_count     number := 0;
  v_ortr_nume varchar2(200);
  v_cant      number := 0;
  v_cant_noca number := 0;

  cursor c_ortr is
    select o.ortr_nume
      from come_orde_trab o, come_vehi v
     where ortr_esta = 'P'
       and o.ortr_vehi_codi = v.vehi_codi
       and o.ortr_clpr_codi = p_sode_clpr_codi
       and (p_sode_sucu_nume_item is null or
           o.ortr_clpr_sucu_nume_item = p_sode_sucu_nume_item)
       and v.vehi_iden = p_vehi_iden;

begin
 if p_vehi_iden is null then
   raise_application_error(-20001,'Debe ingresar el identificador del Veh?culo del Cliente seleccionado.');
   end if;

  if p_sode_nume is null then
    raise_application_error(-20001,
                            'Debe ingresar Nro de Solicitud de Desinstalaci?n.');
  else
    i020286_a.pp_veri_sode_grua(p_sode_nume);
  end if;

  if p_sode_moti is null then
    raise_application_error(-20001,
                            'Debe ingresar un motivo de desinstalaci?n.');
  end if;

  if p_sode_fech_emis is null then
    raise_application_error(-20001,
                            'Debe ingresar la fecha de emisi?n del Anexo.');
  end if;
  
  if p_sode_vehi_codi is null then
    raise_application_error(-20001,'Debe ingresar un identificador valido!!');
    end if;

  select count(*)
    into v_count
    from come_soli_desi
   where sode_codi != nvl(p_sode_codi, -1)
     and sode_vehi_codi = p_sode_vehi_codi
     and nvl(sode_esta, 'P') <> 'L'
     and sode_tipo_moti not in ( 'G','RI', 'R'); ---tipo desinstalacion de grua

  if v_count > 0 then
    raise_application_error(-20001,'El veh?culo esta relacionado a una Solicitud de desinstalaci?n Pendiente o Autorizada.');
  end if;

  for x in c_ortr loop
    v_ortr_nume := v_ortr_nume || x.ortr_nume || ' - ';
    v_cant      := v_cant + 1;
  
    if v_cant > 9 then
      exit;
    end if;
  end loop;

  if v_ortr_nume is not null then
    raise_application_error(-20001,
                            'No puede realizar la solicitud porque existen ' ||
                            v_ortr_nume ||
                            ' OT en estado pendiente asignados al cliente.');
  end if;

  /*if :babmc.noca_nume is not null then
    /*as
    select count(*)
      into v_cant_noca 
      from come_soli_nota_canc
     where nvl(noca_esta,'p') = 'p'
       and noca_nume = :babmc.noca_nume
       and noca_vehi_codi = :babmc.sode_vehi_codi
       and noca_clpr_codi = :babmc.sode_clpr_codi
       and (noca_sucu_nume_item = :babmc.sode_sucu_nume_item or :babmc.sode_sucu_nume_item is null)
     order by noca_nume;
  
    if v_cant_noca = 0 then
      pl_me('la nota de cancelaci?n no corresponde al cliente/vehiculo indicado, favor verifique.');
    end if;
  end if;*/

  i020286_a.pp_validar_nuevo(p_sode_tipo_moti,
                             p_reve_tive_codi,
                             p_reve_mave_codi,
                             p_reve_mode,
                             p_reve_anho,
                             p_reve_colo,
                             p_reve_nume_chas,
                             p_reve_nume_pate);

exception
  when no_data_found then
    null;
end pp_valida;


procedure pp_muestra_clie_vehi(p_vehi_codi in varchar2,
                               p_vehi_nume_pate out varchar2,
                               p_vehi_mode out varchar2,
                               p_vehi_marc out varchar2,
                               p_sode_clpr_codi in out number,
                               p_sode_sucu_nume_item in out varchar2,
                               p_clpr_desc out varchar2,
                               p_clpr_codi_alte out varchar2,
                               p_clpr_clie_clas1_codi out varchar2,
                               p_sucu_desc out varchar2) is
  
  v_clpr_codi number;
  v_sose_sucu_nume_item number;
  v_count number;
  v_deta_esta varchar2(1);
  v_vehi_esta_vehi varchar2(1);
  
begin

  select 
         vehi_clpr_codi sose_clpr_codi,
         vehi_nume_pate deta_nume_pate,
         vehi_mode deta_mode, 
         mave_desc,
         vehi_clpr_sucu_nume_item sose_sucu_nume_item
    into
         v_clpr_codi,
         p_vehi_nume_pate,
         p_vehi_mode,
         p_vehi_marc,
         v_sose_sucu_nume_item
    from come_marc_vehi,
         come_vehi
   where vehi_mave_codi = mave_codi(+)
     and vehi_codi = p_vehi_codi;
  
  if p_sode_clpr_codi is null then
    if v_clpr_codi is not null then
     
  i020286_a.pp_muestra_clie(v_clpr_codi,
                            p_clpr_desc,
                            p_clpr_codi_alte,
                            p_clpr_clie_clas1_codi);
 

     p_sode_clpr_codi := v_clpr_codi;
    end if;
    
    if v_sose_sucu_nume_item is not null then
      p_sode_sucu_nume_item := v_sose_sucu_nume_item;
  

    i020286_a.pp_muestra_come_clpr_sub_cuen(p_sode_clpr_codi,
                                            p_sode_sucu_nume_item,
                                            p_sucu_desc);
    

    end if;
  end if;
  
exception
  when no_data_found then
    raise_application_error(-20001,'Vehiculo Inexistente.');
  when too_many_rows then
   raise_application_error(-20001,'Existe m?s de un vehiculo con el Identificador seleccionado. Favor Veifique!');    
  when others then
    raise_application_error(-20001,'Error '||sqlerrm);
end pp_muestra_clie_vehi;


procedure pp_validar_borrado(p_sode_codi in number,
                             p_sode_esta in varchar2) is
  v_count number(6);
begin

  select count(*)
    into v_count
    from come_orde_trab
   where ortr_sode_codi = p_sode_codi;
  
  if v_count > 0 then 
    raise_application_error(-20001,'Existen '||v_count||' ordenes de trabajo que tienen asignados esta solicitud de desinstalacion. '||
          'Primero se deben borrar o asignar a otro');
  end if;

  if p_sode_esta <> 'P' then
    raise_application_error(-20001,'La solicitud de desinstalaci?n debe estar Pendiente para poder eliminar.');
  end if;

end pp_validar_borrado;



procedure pp_eliminar_registro(p_sode_codi in number) is
  begin
      ----eliminar vehiculo 
       delete from come_rein_inst_vehi c
       where c.reve_sode_codi = p_sode_codi;
       
       ----eliminar solicitud
       delete come_soli_desi
       where sode_codi = p_sode_codi;
       
       
         apex_application.g_print_success_message := 'Nro. Solicitud :' ||
                                                  v('P70_SODE_NUME')||
                                                  ' ,Eliminado Correctamente';
       end pp_eliminar_registro;
       
       

end i020286_a;
