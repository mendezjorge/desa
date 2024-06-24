
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020344" is


  -- pa_devu_fech_habi(p_fech_inic,p_fech_fini );
   
   p_fech_inic          date;
   p_fech_fini          date;
   
   p_codi_base           number:= pack_repl.fa_devu_codi_base;
   p_indi_vali_cabe      varchar2(1):= 'S';
   
   p_conc_codi_anex_rein_vehi number:= to_number(fa_busc_para('p_conc_codi_anex_rein_vehi'));
   p_indi_bloq_reno_desi      varchar2(5000):= ltrim(rtrim(fa_busc_para('p_indi_bloq_reno_desi')));


/********************************************************************/
/*****************   ACTUALIZAR REGISTROS  *************************/
/********************************************************************/   

procedure pp_actualizar_registro(ii_empr_codi in number,
                                 ii_sucu_codi in number,
                                 oo_resp_codi out number,
                                 oo_resp_desc out varchar2) is

begin



  begin
  I020344.pp_validaciones;
  end;


-- actualizamos TODO TODILLO
  begin
  
  I020344.pp_actualiza_anex_deta(i_empr_codi => ii_empr_codi,
                                 i_sucu_codi => ii_sucu_codi,
                                 o_resp_codi => oo_resp_codi,
                                 o_resp_desc => oo_resp_desc);
 exception 
   when others then 
     raise_application_error(-20010, 'Error al momento de actualizar detalle: '||sqlerrm);
 end;



end;


procedure pp_actualiza_anex_deta(i_empr_codi in number,
                                 i_sucu_codi in number,
                                 o_resp_codi out number,
                                 o_resp_desc out varchar2) is

  v_codResp           number;
  v_descResp          varchar2(100);
  v_anex_dura_cont    number;
  v_fech_vige         date;
  
  
  cursor c_det_cont_a is 
select taax_c001 clpr_codi,
       taax_c002 clpr_codi_alte,
       taax_c003 clpr_desc,
       taax_c004 sose_codi,
       taax_c005 sose_nume,
       taax_c006 sose_fech_emis,
       taax_c007 anex_codi,
       taax_c008 anex_nume,
       taax_c009 anex_nume_refe,
       taax_c010 s_refe,
       taax_c011 anex_fech_inic,
       to_number(taax_c012) anex_impo_mone,
       taax_c013 mone_desc_abre,
       taax_c014 anex_fech_vige,
       taax_c015 anex_dura_cont,
       taax_c016 anex_dura_cont_nuev,
       taax_c017 cantidad_anexo,
       taax_c018 v_ulti_movi_nume,
       taax_c019 v_ulti_movi_fech_emis,
       taax_c020 v_clpr_cli_situ_codi,
       taax_c021 v_clpr_indi_vali_situ_clie,
       taax_c022 v_clpr_indi_exce,
       taax_c023 anex_nume_poli,
       taax_c024 anex_nume_orde_serv,
       taax_c025 anex_fech_inic_poli,
       taax_c026 anex_fech_fini_poli,
       taax_seq seq
  from come_tabl_auxi
 where taax_sess = v('APP_SESSION')
   and taax_user = gen_user
   and taax_c040 = 'S';
  
begin
  
  
  
  for i in c_det_cont_a loop
    
      if nvl(i.anex_dura_cont_nuev, 0) <= 0 then
        v_anex_dura_cont := i.anex_dura_cont;
      else
        v_anex_dura_cont := i.anex_dura_cont_nuev;
      end if;
     
      
      if i.anex_fech_inic_poli is not null then
        v_fech_vige := i.anex_fech_inic_poli;
      else
        v_fech_vige := i.anex_fech_vige;
      end if;
      
     
    pack_fact_ciclo.bkp_pa_gene_reno_plan_cont (i_empr_codi,
                                                i.anex_codi,                                         
                                                v_fech_vige,
                                                v_anex_dura_cont,
                                                i.anex_nume_poli,
                                                i.anex_nume_orde_serv,
                                                i.anex_fech_inic_poli,
                                                i.anex_fech_fini_poli,
                                                i_sucu_codi,
                                                v_codResp,
                                                v_descResp);
    
   o_resp_codi := v_codResp;
   o_resp_desc := v_descResp;
insert into come_concat (campo1, otro) values (v_codResp||v_descResp, 'este viernes ya es locooo');
    
  end loop; 
  
end;

/********************************************************************/
/*****************         VALIDACIONES     *************************/
/********************************************************************/   



procedure pp_validaciones is

  v_sose_sucu_nume_item number;

cursor c_det_cont is 
select taax_c001 clpr_codi,
       taax_c002 clpr_codi_alte,
       taax_c003 clpr_desc,
       taax_c004 sose_codi,
       taax_c005 sose_nume,
       taax_c006 sose_fech_emis,
       taax_c007 anex_codi,
       taax_c008 anex_nume,
       taax_c009 anex_nume_refe,
       taax_c010 s_refe,
       taax_c011 anex_fech_inic,
       to_number(taax_c012) anex_impo_mone,
       taax_c013 mone_desc_abre,
       taax_c014 anex_fech_vige,
       taax_c015 anex_dura_cont,
       taax_c016 anex_dura_cont_nuev,
       taax_c017 cantidad_anexo,
       taax_c018 v_ulti_movi_nume,
       taax_c019 v_ulti_movi_fech_emis,
       taax_c020 v_clpr_cli_situ_codi,
       taax_c021 v_clpr_indi_vali_situ_clie,
       taax_c022 v_clpr_indi_exce,
       taax_c023 anex_nume_poli,
       taax_c024 anex_nume_orde_serv,
       taax_c025 anex_fech_inic_poli,
       taax_c026 anex_fech_fini_poli,
       taax_seq seq
  from come_tabl_auxi
 where taax_sess = v('APP_SESSION')
   and taax_user = gen_user
   and taax_c040 = 'S';

begin
  

for i in c_det_cont loop

  begin
    select sose_sucu_nume_item
      into v_sose_sucu_nume_item
      from come_soli_serv, come_soli_serv_anex
     where sose_codi = anex_sose_codi
       and anex_codi = i.anex_codi
     group by sose_sucu_nume_item;
  exception
    when no_data_found then
      v_sose_sucu_nume_item := null;
  end;

  if v_sose_sucu_nume_item is not null then
    if i.anex_nume_poli is null then
      raise_application_error(-20010,'El Anexo no tiene Nro de Poliza.');
    end if;
    if i.anex_nume_orde_serv is null then
      raise_application_error(-20010,'El Anexo no tiene Orden de Seguro.');
    end if;
    if i.anex_fech_inic_poli is null then
      raise_application_error(-20010,'El Anexo no tiene fecha inicio poliza.');
    end if;
    if i.anex_fech_fini_poli is null then
      raise_application_error(-20010,'El Anexo no tiene fecha fin poliza.');
    end if;
  else
    i.anex_nume_poli      := null;
    i.anex_nume_orde_serv := null;
    i.anex_fech_inic_poli := null;
    i.anex_fech_fini_poli := null;
  end if;


  pa_devu_fech_habi(p_fech_inic,p_fech_fini );
   

  --if i.anex_fech_vige not between p_fech_inic and p_fech_fini then           
  if i.anex_fech_vige > p_fech_fini then
    raise_application_error(-20010,'Solo se puede renovar anexos de fecha que no superen el fin del periodo ' ||
          to_char(p_fech_fini, 'dd-mm-yyyy'));
  end if;

  if i.anex_impo_mone <= 0 then
    raise_application_error(-20010,'El Contrato no tiene importe de Anexo.');
  end if;

  if nvl(i.anex_dura_cont_nuev, 0) <= 0 then
    if nvl(i.anex_dura_cont, 0) <= 0 then
      raise_application_error(-20010,'El Contrato no tiene duracion asignada.');
    end if;
    
  end if;


--validamos OT pendientes
 begin
 I020344.pp_veri_ot_pend(i.anex_codi, i.sose_nume, i.anex_nume);
 end;

end loop;

--validamos situacion del cliente
 begin
  I020344.pp_deter_situ_clie2(p_indi_mens => 'S');
 end;
 
end;


procedure pp_veri_ot_pend(p_anex_codi in number,
                          p_sose_nume in number,
                          p_anex_nume in number) is

  cursor c_anex_deta is
    select v.vehi_codi, v.vehi_iden
      from come_soli_serv_anex a, come_soli_serv_anex_deta ad, come_vehi v
     where a.anex_codi = ad.deta_anex_codi
       and ad.deta_vehi_codi = v.vehi_codi
       and nvl(v.vehi_esta, 'I') <> 'D'
       and nvl(ad.deta_esta_plan, 'S') = 'S'
       and a.anex_codi = p_anex_codi
     order by v.vehi_codi;

  cursor c_anex_deta_desi is
    select v.vehi_codi, v.vehi_iden
      from come_soli_serv_anex a, come_soli_serv_anex_deta ad, come_vehi v
     where a.anex_codi = ad.deta_anex_codi
       and ad.deta_vehi_codi = v.vehi_codi
       and nvl(v.vehi_esta, 'I') = 'D'
       and nvl(ad.deta_esta_plan, 'S') = 'S'
       and a.anex_codi = p_anex_codi
     order by v.vehi_codi;

  v_cant number := 0;

begin
  if nvl(p_indi_bloq_reno_desi, 'N') = 'S' then
    for x in c_anex_deta_desi loop
      begin
        select count(*)
          into v_cant
          from come_orde_trab ot
         where ot.ortr_vehi_codi = x.vehi_codi
           and ot.ortr_esta = 'P';
      end;
    
      if v_cant > 0 then
        raise_application_error(-20010,'El Contrato Nro ' || p_sose_nume || ' Anexo ' ||
              p_anex_nume || ' no podra ser renovado.' ||
              ' Ya que el vehiculo con Iden. ' || x.vehi_iden ||
              ' posee OT de Desinstalacion en estado pendiente.');
      end if;
    end loop;
  else
    for x in c_anex_deta loop
      begin
        select count(*)
          into v_cant
          from come_orde_trab ot
         where ot.ortr_vehi_codi = x.vehi_codi
           and ot.ortr_esta = 'P';
      end;
    
      if v_cant > 0 then
        raise_application_error(-20010,'El Contrato Nro ' || p_sose_nume || ' Anexo ' ||
              p_anex_nume || ' posee un' || ' vehiculo con Iden. ' ||
              x.vehi_iden || ' posee aun OTs en estado pendiente.');
        /*raise_application_error(-20010,'El Contrato Nro '||p_sose_nume||' Anexo '||p_anex_nume||' no podra ser renovado.'||
        ' Ya que el vehiculo con Iden. '||x.vehi_iden||' posee aun OTs en estado pendiente.');*/
      end if;
    end loop;
  end if;

end;

/********************************************************************/
/***************** CARGAR Y VALIDAR CAMPOS  *************************/
/********************************************************************/

procedure pp_muestra_come_sose_nume(p_sose_nume      in number,
                                    p_clpr_codi      in number,
                                    p_sose_codi      out number,
                                    p_sose_fech_emis out date) is

begin

  select sose_codi, sose_fech_emis
    into p_sose_codi, p_sose_fech_emis
    from come_soli_serv, come_clie_prov
   where sose_clpr_codi = clpr_codi
     and (clpr_codi = p_clpr_codi or p_clpr_codi is null)
     and nvl(sose_tipo, 'I') <> 'N'
     and sose_nume = p_sose_nume;

exception
  when no_data_found then
    p_sose_codi      := null;
    p_sose_fech_emis := null;
    raise_application_error(-20010,'Solicitud de Servicio inexistente.');
  when others then
    raise_application_error(-20010, 'Error muestra contrato '||sqlerrm);
end;
     
procedure pp_muestra_anex(p_anex_codi in number, 
                          p_sose_codi in number, 
                          i_empr_codi in number,
                          p_anex_fech_emis out date,
                          p_anex_nume_refe out number) is

begin
  select anex_fech_emis, anex_nume_refe
    into p_anex_fech_emis, p_anex_nume_refe
    from come_soli_serv_anex
   where anex_codi = p_anex_codi
   --  and (anex_sose_codi = p_sose_codi or p_sose_codi is null)
     and anex_empr_codi = i_empr_codi
     and anex_esta = 'A';

exception 
  when no_data_found then 
    raise_application_error(-20010, 'No se encontro nadaa '||p_anex_codi|| ' ' ||i_empr_codi);
end;


procedure pp_ejecutar_consulta(i_clpr_codi                in number,
                              i_sose_codi                 in number,
                              i_anex_codi                 in number,
                              i_deta_tive_codi            in number,
                              i_deta_nume_pate            in number,
                              i_deta_nume_chas            in varchar2,
                              i_vehi_iden                 in varchar2,
                              i_clpr_cli_situ_codi        in number,                             
                              p_sucu_codi                 in number,
                              i_clas1_codi                in number,
                              i_indi_excl_clie_clas1_aseg in varchar2,                              
                              i_fech_venc_desd            in date,
                              i_fech_venc_hast            in date,
                              i_cant_dias_venc            in number) is
                              

  v_ulti_movi_nume             come_movi.movi_nume%type;
  v_ulti_movi_fech_emis        come_movi.movi_fech_emis%type;


  v_clpr_cli_situ_codi         come_clie_prov.clpr_cli_situ_codi%type;
  v_clpr_indi_vali_situ_clie   come_clie_prov.clpr_indi_vali_situ_clie%type;
  v_clpr_indi_exce             come_clie_prov.clpr_indi_exce%type;


  ta_reno_plan_deta pack_fact_ciclo.tt_reno_plan_deta;
  v_user_codi       number;

begin

--raise_application_error(-20010, i_sose_codi||' HOLA');

pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'),
                                   i_taax_user => gen_user);

  begin
    select user_codi
      into v_user_codi
      from segu_user
     where user_login = gen_user;
  end;


  pack_fact_ciclo.pa_cons_reno_plan(i_clpr_codi,
                                    i_sose_codi,
                                    i_anex_codi,
                                    i_deta_tive_codi,
                                    i_deta_nume_pate,
                                    i_deta_nume_chas,
                                    i_vehi_iden,
                                    i_clpr_cli_situ_codi,
                                    v_user_codi,
                                    p_sucu_codi,
                                    i_clas1_codi,
                                    nvl(i_indi_excl_clie_clas1_aseg, 'N'),
                                    i_fech_venc_desd,
                                    i_fech_venc_hast,
                                    i_cant_dias_venc,
                                    ta_reno_plan_deta);


  if ta_reno_plan_deta.count > 0 then
    --for x in 1 .. ta_reno_plan_deta.count loop
      
    FOR x IN ta_reno_plan_deta.FIRST .. ta_reno_plan_deta.LAST LOOP
    
    
     begin
        select m.movi_nume, m.movi_fech_emis
          into v_ulti_movi_nume, v_ulti_movi_fech_emis
          from come_movi m
         where m.movi_codi in
               (select max(ap.anpl_movi_codi)
                  from come_soli_serv_anex_plan ap
                 where ap.anpl_anex_codi = ta_reno_plan_deta(x).anex_codi);
      exception
        when no_data_found then
          v_ulti_movi_nume      := null;
          v_ulti_movi_fech_emis := null;
      end;
    
    
     ---determinar situacion del cliente
      begin
        select clpr_cli_situ_codi,
               nvl(clpr_indi_vali_situ_clie, 'S'),
               clpr_indi_exce
          into v_clpr_cli_situ_codi,
               v_clpr_indi_vali_situ_clie,
               v_clpr_indi_exce
          from come_clie_prov
         where clpr_codi = ta_reno_plan_deta(x).clpr_codi;
      exception
        when no_data_found then
          v_clpr_cli_situ_codi       := null;
          v_clpr_indi_vali_situ_clie := null;
          v_clpr_indi_exce           := null;
      end;
    
    
       INSERT INTO come_tabl_auxi 
             (taax_sess,
              taax_user,
              taax_seq,
              taax_c001, 
              taax_c002, 
              taax_c003, 
              taax_c004, 
              taax_c005, 
              taax_c006, 
              taax_c007, 
              taax_c008, 
              taax_c009, 
              taax_c010, 
              taax_c011, 
              taax_c012, 
              taax_c013, 
              taax_c014, 
              taax_c015, 
              taax_c016,
              taax_c017,
              taax_c018,
              taax_c019,
              taax_c020,
              taax_c021,
              taax_c022,
              taax_c040)
             
       VALUES (v('APP_SESSION'),
               gen_user,
               seq_come_tabl_auxi.nextval,
               ta_reno_plan_deta(x).clpr_codi,
               ta_reno_plan_deta(x).clpr_codi_alte,
               ta_reno_plan_deta(x).clpr_desc,
               ta_reno_plan_deta(x).sose_codi,
               ta_reno_plan_deta(x).sose_nume,
               ta_reno_plan_deta(x).sose_fech_emis,
               ta_reno_plan_deta(x).anex_codi,              
               ta_reno_plan_deta(x).anex_nume,
               ta_reno_plan_deta(x).anex_nume_refe,
               ta_reno_plan_deta(x).anex_nume_refe || '/' || ta_reno_plan_deta(x).anex_nume,              
               ta_reno_plan_deta(x).anex_fech_inic_vige,
               ta_reno_plan_deta(x).anex_impo_mone,
               ta_reno_plan_deta(x).mone_desc_abre,
               ta_reno_plan_deta(x).anex_fech_vige,
               ta_reno_plan_deta(x).anex_dura_cont,
               ta_reno_plan_deta(x).anex_dura_cont,
               (select count(*)
                  from come_soli_serv_anex_deta ad,
                       come_soli_serv_anex      a,
                       come_vehi                v
                 where a.anex_codi = ad.deta_anex_codi
                   and ad.deta_vehi_codi = v.vehi_codi
                   and v.vehi_esta <> 'D'
                   and ad.deta_conc_codi <> p_conc_codi_anex_rein_vehi
                   and a.anex_codi = ta_reno_plan_deta(x).anex_codi),
                v_ulti_movi_nume, 
                v_ulti_movi_fech_emis,
                v_clpr_cli_situ_codi,    
                v_clpr_indi_vali_situ_clie, 
                v_clpr_indi_exce,
                'N');           
   
   

    end loop;
  
  end if;

  --pp_cargar_totales;

end;

procedure pp_deter_situ_clie (p_indi_mens in varchar2) is
v_dias_atra number;                                           
v_situ_codi number;
v_situ_indi_auma varchar2(1);
v_situ_indi_fact varchar2(1);
    
v_situ_colo   varchar2(1);
v_situ_desc   varchar2(60);


cursor c_situ is
select taax_c001 clpr_codi,
       taax_c003 clpr_desc,
       taax_c020 clpr_cli_situ_codi,
       taax_c021 clpr_indi_vali_situ_clie,
       taax_c022 clpr_indi_exce
  from come_tabl_auxi
 where taax_sess = v('APP_SESSION')
   and taax_user = gen_user
   and taax_c040 = 'N';


begin 
  


for I in c_situ loop

  --- primero determinamos si la situacion actual es o no manual
  if i.clpr_cli_situ_codi is not null then
    begin     
       select situ_indi_auma , situ_indi_fact,   situ_colo,   situ_desc
       into  v_situ_indi_auma, v_situ_indi_fact, v_situ_colo, v_situ_desc
       from come_situ_clie
       where situ_codi = i.clpr_cli_situ_codi;     

    exception
       When others then             
          v_situ_indi_auma := 'A';
          v_situ_indi_fact := null;
          v_situ_colo      := null;
          v_situ_desc      := null;
    end; 
  else  
     v_situ_indi_auma := 'A';
     v_situ_indi_fact := 'S';
     v_situ_colo      := null;
     v_situ_desc      := null;    
  end if; 
  
  
  
  

  if v_situ_indi_auma = 'A' then --si es automatico se realiza un refresh para determinar la situacion en el momento    
    v_dias_atra := fa_devu_dias_atra_clie(i.clpr_codi);
    begin
      
      select situ_colo, situ_indi_fact, situ_desc
        into v_situ_colo, v_situ_indi_fact, v_situ_desc
        from come_situ_clie
       where v_dias_atra between situ_dias_atra_desd and
             situ_dias_atra_hast;
             
    exception
      when no_data_found then
        v_situ_colo      := 'B';
        v_situ_indi_fact := 'S';
        v_situ_desc      := ' ';
      when too_many_rows then
        raise_application_error(-20010,'Existe mas de una situacion de cliente que contiene '||v_dias_atra||' dias de atraso dentro de su rango. Para el cliente '||i.clpr_desc);      
    end;
  end if;
  
  ---setear el color 
  if v_situ_colo = 'R' then --Rojo
    
    insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_seq,
       taax_c001,
       taax_c002,
       taax_c003,
       taax_c041)
    values
      (v('APP_SESSION'),
       gen_user,
       seq_come_tabl_auxi.nextval,
       v_situ_colo,
       v_situ_indi_fact,
       v_situ_desc,
       'A');
  elsif v_situ_colo = 'G' then  
    
  insert into come_tabl_auxi
    (taax_sess,
     taax_user,
     taax_seq,
     taax_c001,
     taax_c002,
     taax_c003,
     taax_c041)
  values
    (v('APP_SESSION'),
     gen_user,
     seq_come_tabl_auxi.nextval,
     v_situ_colo,
     v_situ_indi_fact,
     v_situ_desc,
     'A');
    
                                                                             
    
  elsif v_situ_colo = 'A' then --Amarillo
    
  insert into come_tabl_auxi
    (taax_sess,
     taax_user,
     taax_seq,
     taax_c001,
     taax_c002,
     taax_c003,
     taax_c041)
  values
    (v('APP_SESSION'),
     gen_user,
     seq_come_tabl_auxi.nextval,
     v_situ_colo,
     v_situ_indi_fact,
     v_situ_desc,
     'A');
  
    
  elsif v_situ_colo = 'B' then --Blanco
    
     insert into come_tabl_auxi
       (taax_sess,
        taax_user,
        taax_seq,
        taax_c001,
        taax_c002,
        taax_c003,
        taax_c041)
     values
       (v('APP_SESSION'),
        gen_user,
        seq_come_tabl_auxi.nextval,
        v_situ_colo,
        v_situ_indi_fact,
        v_situ_desc,
        'A'); 
        
  elsif v_situ_colo = 'Z' then --azul
    
    insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_seq,
       taax_c001,
       taax_c002,
       taax_c003,
       taax_c041)
    values
      (v('APP_SESSION'),
       gen_user,
       seq_come_tabl_auxi.nextval,
       v_situ_colo,
       v_situ_indi_fact,
       v_situ_desc,
       'A');
       
    
  elsif v_situ_colo = 'N' then --Naranja
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_indi_fact,
         v_situ_desc,
         'A'); 
    
  else
    
    insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_seq,
       taax_c001,
       taax_c002,
       taax_c003,
       taax_c041)
    values
      (v('APP_SESSION'),
       gen_user,
       seq_come_tabl_auxi.nextval,
       v_situ_colo,
       v_situ_indi_fact,
       v_situ_desc,
       'A'); 
       
    
  end if;         


  
  
  if p_indi_mens = 'S' then
    
    if  nvl(i.clpr_indi_vali_situ_clie, 'S') = 'S' then
      
      if nvl(v_situ_indi_fact, 'N') = 'N'  then
        
        if nvl(i.clpr_indi_exce, 'N') = 'S' then -- Si esta en Excepcion solo se advierte
          raise_application_error(-20010,'Atencion, El cliente '||i.clpr_desc||' se encuentra en la situacion '||v_situ_desc);
        else
          raise_application_error(-20010,'Atencion, No se podra renovar al cliente '||i.clpr_desc||'. Se encuentra en la situacion '||v_situ_desc);        
        end if;
      end if;
    end if;
  end if;
  
 end loop; 
 
   if p_indi_mens <> 'S' then 
        -- cargamos el resto
       begin
        I020344.pp_cargar_totales;
      end;
   end if; 

end;

procedure pp_deter_situ_clie2 (p_indi_mens in varchar2) is
v_dias_atra number;                                           
v_situ_codi number;
v_situ_indi_auma varchar2(1);
v_situ_indi_fact varchar2(1);
    
v_situ_colo   varchar2(1);
v_situ_desc   varchar2(60);


cursor c_situ is
select taax_c001 clpr_codi,
       taax_c003 clpr_desc,
       taax_c020 clpr_cli_situ_codi,
       taax_c021 clpr_indi_vali_situ_clie,
       taax_c022 clpr_indi_exce
  from come_tabl_auxi
 where taax_sess = v('APP_SESSION')
   and taax_user = gen_user
   and taax_c040 = 'S';


begin 
  
  for I in c_situ loop
  --- primero determinamos si la situacion actual es o no manual
  if i.clpr_cli_situ_codi is not null then
    begin     
       select situ_indi_auma , situ_indi_fact,   situ_colo,   situ_desc
       into  v_situ_indi_auma, v_situ_indi_fact, v_situ_colo, v_situ_desc
       from come_situ_clie
       where situ_codi = i.clpr_cli_situ_codi;     

    exception
       When others then             
          v_situ_indi_auma := 'A';
          v_situ_indi_fact := null;
          v_situ_colo      := null;
          v_situ_desc      := null;
    end; 
  else  
     v_situ_indi_auma := 'A';
     v_situ_indi_fact := 'S';
     v_situ_colo      := null;
     v_situ_desc      := null;    
  end if; 



  
  if p_indi_mens = 'S' then
    
    if  nvl(i.clpr_indi_vali_situ_clie, 'S') = 'S' then
      
      if nvl(v_situ_indi_fact, 'N') = 'N'  then
        
        if nvl(i.clpr_indi_exce, 'N') = 'S' then -- Si esta en Excepcion solo se advierte
          raise_application_error(-20010,'Atencion, El cliente '||i.clpr_desc||' se encuentra en la situacion: '||i.clpr_cli_situ_codi);
        else
          raise_application_error(-20010,'Atencion, No se podra renovar al cliente '||i.clpr_desc||'. Se encuentra en la situacion: '||i.clpr_cli_situ_codi);        
        end if;
      end if;
    end if;
  end if;
  
 end loop; 
 


end;


procedure pp_cargar_totales is

  cursor c_situ is
    select situ_codi, situ_desc, situ_colo
      from come_situ_clie
     where situ_empr_codi = V('AI_EMPR_CODI')
     order by situ_codi;

  type rt_situ is record(
    situ_codi number,
    situ_desc varchar2(100),
    situ_colo varchar2(20),
    situ_cant number);

  type tt_situ is table of rt_situ index by binary_integer;
  ta_situ tt_situ;

  v_idx number := 0;

  v_situ_codi number;
  v_situ_desc varchar2(100);
  v_situ_colo varchar2(20);
  v_situ_cant number;


cursor c_situ_deta is
select taax_c020 clpr_cli_situ_codi
  from come_tabl_auxi
 where taax_sess = v('APP_SESSION')
   and taax_user = gen_user
   and taax_c040 = 'N';

begin

  for x in c_situ loop
    v_idx := v_idx + 1;
    ta_situ(v_idx).situ_codi := x.situ_codi;
    ta_situ(v_idx).situ_desc := x.situ_desc;
    ta_situ(v_idx).situ_colo := x.situ_colo;
    ta_situ(v_idx).situ_cant := 0;
  end loop;


  for i in c_situ_deta loop
    for x in 1 .. ta_situ.count loop
      if ta_situ(x).situ_codi = i.clpr_cli_situ_codi then
        ta_situ(x).situ_cant := nvl(ta_situ(x).situ_cant, 0) + 1;
      end if;
    end loop;
  

  end loop;

  for x in 1 .. ta_situ.count loop
    v_situ_codi := ta_situ(x).situ_codi;
    v_situ_desc := ta_situ(x).situ_desc;
    v_situ_colo := ta_situ(x).situ_colo;
    v_situ_cant := ta_situ(x).situ_cant;
  
    ---setear el color 
    if v_situ_colo = 'R' then
      --Rojo
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
       
    elsif v_situ_colo = 'G' then
      
     insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
         
    elsif v_situ_colo = 'A' then
      --Amarillo
      
     insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
         
    elsif v_situ_colo = 'B' then
      --Blanco
      
     insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
         
    elsif v_situ_colo = 'Z' then
      --azul
      
     insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
         
    elsif v_situ_colo = 'N' then
      --Naranja
      
     insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
         
    else
      
     insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c041)
      values
        (v('APP_SESSION'),
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_situ_colo,
         v_situ_desc,
         v_situ_codi,
         v_situ_cant,
         'C');
         
    end if;


  end loop;

end;


end I020344;
