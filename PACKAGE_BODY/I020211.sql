
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020211" is

  p_codi_base           number := pack_repl.fa_devu_codi_base;
  p_codi_timo_reem      number := to_number(fa_busc_para('p_codi_timo_reem'));
  p_indi_most_mens_sali varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali')));
  p_cant_dias_auto_salt varchar2(500) := ltrim(rtrim(fa_busc_para('p_cant_dias_auto_salt')));

  procedure pp_actu_regi(i_resa_codi      in number,
                         i_resa_tare_codi in number,
                         i_resa_nume_comp in number,
                         i_resa_fech_rend in date,
                         i_resa_obse      in varchar2,
                         i_resa_esta      in varchar2,
                         i_resa_empr_codi in number,
                         i_tipo_acti      in varchar2) is
  
    v_cont number;
  begin
    select count(*)
      into v_cont
      from come_movi
     where movi_nume = i_resa_nume_comp
       and movi_timo_codi = 13;
  
    if v_cont > 0 then
      raise_application_error(-20010,
                              'El Nro. del Comprobante ya se encuentra cargado en el Sistema!!!');
    end if;
  
    if i_tipo_acti = 'I' then
      insert into come_reci_salt_auto
        (resa_codi,
         resa_tare_codi,
         resa_nume_comp,
         resa_fech_rend,
         resa_obse,
         resa_fech_grab,
         resa_logi,
         resa_esta,
         resa_base,
         resa_empr_codi,
         resa_codi_alte)
      values
        (i_resa_codi,
         i_resa_tare_codi,
         i_resa_nume_comp,
         i_resa_fech_rend,
         i_resa_obse,
         sysdate,
         gen_user,
         i_resa_esta,
         p_codi_base,
         i_resa_empr_codi,
         i_resa_codi);
    
    elsif i_tipo_acti = 'U' then
    
      update come_reci_salt_auto
         set resa_tare_codi = i_resa_tare_codi,
             resa_nume_comp = i_resa_nume_comp,
             resa_fech_rend = i_resa_fech_rend,
             resa_obse      = i_resa_obse,
             resa_esta      = i_resa_esta,
             resa_user_modi = gen_user,
             resa_fech_modi = sysdate
       where resa_codi = i_resa_codi;
    
    elsif i_tipo_acti = 'D' then
    
      delete come_reci_salt_auto where resa_codi = i_resa_codi;
    
    end if;
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_actu_regi;

  procedure pp_cargar_descr_nro_docu(o_timo_codi out number,
                                     o_tico_desc out varchar2) is
  
    v_resa_tico_codi number;
    v_tico_desc      varchar2(500);
  
  begin
  
    ---- por ahora el programa solo funcionara para recibo emitido  
    begin
      select timo_tico_codi
        into v_resa_tico_codi
        from come_tipo_movi
       where timo_codi = p_codi_timo_reem;
    
    exception
      when no_data_found then
        raise_application_error(-20010,
                                'El tipo de movimiento recibo emitido no esta enlazado con el tipo de comprobante recibo.');
    end;
  
    select tico_desc
      into v_tico_desc
      from come_tipo_comp
     where tico_codi = v_resa_tico_codi;
    --------------------------------------------------------------  
  
    o_timo_codi := v_resa_tico_codi;
    o_tico_desc := v_tico_desc;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Comprobante inexistente!');
  end pp_cargar_descr_nro_docu;

  procedure pp_vali_nume(i_resa_nume_comp in number) is
    v_cont number;
  begin
    select count(*)
      into v_cont
      from come_movi
     where movi_nume = i_resa_nume_comp
       and movi_timo_codi = 13;
  
    if v_cont > 0 then
      raise_application_error(-20010,
                              'El Nro. del Comprobante ya se encuentra cargado en el Sistema!!!');
    end if;
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error el momento de validar nro de documento: ' ||
                              sqlerrm);
  end;

  procedure pp_veri_comp_cobr(i_resa_nume_comp in number,
                              i_resa_tico_codi in number,
                              resa_tare_codi   out number) is
  begin
    select tare_codi --, tare_empl_codi
      into resa_tare_codi --, i_resa_empl_codi
      from come_talo_reci
     where i_resa_nume_comp between tare_reci_desd and tare_reci_hast
       and tare_esta = 'A'
       and tare_tico_codi = i_resa_tico_codi;
  exception
    when no_data_found then
      resa_tare_codi := null;
      raise_application_error(-20010,
                              'El comprobante aun no fue asignado a ningun cobrador o el talonario ya no esta Activo.');
  end;

  procedure pp_vali_fech(i_resa_fech_rend in date,
                         i_resa_fech_grab in date) is
  begin
  
    if i_resa_fech_grab is not null and
       (i_resa_fech_rend >=
       (trunc(i_resa_fech_grab) + nvl(p_cant_dias_auto_salt, 0))) then
      raise_application_error(-20010,
                              'Ha superado la fecha límite para realizar modificaciones a los saltos');
    end if;
  
    if i_resa_fech_grab is null then
      if (i_resa_fech_rend - trunc(sysdate)) >=
         nvl(p_cant_dias_auto_salt, 0) then
        raise_application_error(-20010,
                                'La fecha ingresada supera al limite ingresado en el parametro de cantidad de dias de auorizacion');
      end if;
    else
      if (i_resa_fech_rend - trunc(i_resa_fech_grab)) >=
         nvl(p_cant_dias_auto_salt, 0) then
        raise_application_error(-20010,
                                'La fecha ingresada supera al limite ingresado en el parametro de cantidad de dias de auorizacion');
      end if;
    
    end if;
  
  end pp_vali_fech;

  procedure pl_muestra_come_empl(p_empl_codi in number,
                                 p_empl_desc out char,
                                 p_empl_tipo in number) is
  begin
    select empl_desc
      into p_empl_desc
      from come_empl, come_empl_tiem
     where empl_codi = emti_empl_codi
       and empl_codi = p_empl_codi
       and emti_tiem_codi = p_empl_tipo;
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_gene_repo(i_resa_codi in number) is
  
    type tr_repo is record(
      v_session        number,
      v_login          varchar2(50),
      v_resa_codi      come_reci_salt_auto.resa_codi%type,
      v_empl_codi_alte come_empl.empl_codi_alte%type,
      v_empl_desc      come_empl.empl_desc%type,
      v_tico_desc      come_tipo_comp.tico_desc%type,
      v_resa_nume_comp come_reci_salt_auto.resa_nume_comp%type,
      v_resa_fech_rend come_reci_salt_auto.resa_fech_rend%type,
      v_resa_fech_grab come_reci_salt_auto.resa_fech_grab%type,
      v_resa_logi      come_reci_salt_auto.resa_logi%type,
      v_resa_esta      come_reci_salt_auto.resa_esta%type,
      v_seq            number);
  
    type tt_repo is table of tr_repo index by binary_integer;
    ta_repo tt_repo;
  
    v_cant_regi number := 0;
    v_para      varchar2(500);
    v_cont      varchar2(500);
    v_repo      varchar2(500);
  
    salir exception;
  
  begin
  
    begin
      pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'),
                                         i_taax_user => gen_user);
    end;
  
    if i_resa_codi is not null then
    
      select v('APP_SESSION'),
             gen_user,
             a.resa_codi,
             nvl(e.empl_codi_alte, e.empl_codi) empl_codi_alte,
             e.empl_desc,
             c.tico_desc,
             a.resa_nume_comp,
             a.resa_fech_rend,
             a.resa_fech_grab,
             a.resa_logi,
             a.resa_esta,
             seq_come_tabl_auxi.nextval
        bulk collect
        into ta_repo
        from come_reci_salt_auto a,
             come_talo_reci      t,
             come_empl           e,
             come_tipo_comp      c
       where a.resa_tare_codi = t.tare_codi(+)
         and t.tare_empl_codi = e.empl_codi(+)
         and t.tare_tico_codi = c.tico_codi(+)
         and a.resa_codi = i_resa_codi;
    
    else
    
      select v('APP_SESSION'),
             gen_user,
             a.resa_codi,
             nvl(e.empl_codi_alte, e.empl_codi) empl_codi_alte,
             e.empl_desc,
             c.tico_desc,
             a.resa_nume_comp,
             a.resa_fech_rend,
             a.resa_fech_grab,
             a.resa_logi,
             a.resa_esta,
             seq_come_tabl_auxi.nextval
        bulk collect
        into ta_repo
        from come_reci_salt_auto a,
             come_talo_reci      t,
             come_empl           e,
             come_tipo_comp      c
       where a.resa_tare_codi = t.tare_codi(+)
         and t.tare_empl_codi = e.empl_codi(+)
         and t.tare_tico_codi = c.tico_codi(+);
    
    end if;
  
    v_cant_regi := ta_repo.count;
  
    --RAISE_APPLICATION_ERROR(-20010, 'eSOT ES LA CANTIDAD DE REGIS: '||v_cant_regi||i_resa_codi);
    for x in 1 .. v_cant_regi loop
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_seq)
      values
        (ta_repo(x).v_session,
         ta_repo(x).v_login,
         ta_repo(x).v_resa_codi,
         ta_repo(x).v_empl_codi_alte,
         ta_repo(x).v_empl_desc,
         ta_repo(x).v_tico_desc,
         ta_repo(x).v_resa_nume_comp,
         ta_repo(x).v_resa_fech_rend,
         ta_repo(x).v_resa_fech_grab,
         ta_repo(x).v_resa_logi,
         ta_repo(x).v_resa_esta,
         ta_repo(x).v_seq);
    
    end loop;
  
    v_cont := 'p_app_session:p_app_user';
    v_para := v('APP_SESSION') || ':' || gen_user;
    v_repo := 'I020211';
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, gen_user, v_repo, 'pdf', v_cont);
  
    commit;
  
  end pp_gene_repo;

end I020211;
