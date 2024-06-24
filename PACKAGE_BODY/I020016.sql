
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020016" is

  p_fech_inic           date;
  p_fech_fini           date;

  v_movi_codi           number;
  v_movi_dbcr           char(1);
  v_sum_cheq_impo       number;
  p_cant_deci_mmnn      number:= to_number(fa_busc_para ('p_cant_deci_mmnn'));
  p_codi_mone_mmnn      number:= to_number(fa_busc_para ('p_codi_mone_mmnn'));
  p_codi_conc           number:= to_number(fa_busc_para ('p_codi_conc_cheq_cred'));
  p_codi_impu_exen      number:= to_number(fa_busc_para ('p_codi_impu_exen'));
  p_codi_timo_depo_banc number:= to_number(fa_busc_para ('p_codi_timo_depo_banc'));
  p_codi_timo_extr_banc number:= to_number(fa_busc_para ('p_codi_timo_extr_banc'));
  p_tica_codi           number;
   p_codi_base           number:= pack_repl.fa_devu_codi_base;

  type r_bsel is record(
      movi_codi_depo number,
      movi_nume_depo number,
      movi_fech_depo varchar2(10),
      movi_cuen_codi number,
      movi_mone_codi number
  );

  bsel r_bsel;

  type r_parameter is record(
      p_codi_timo_depo_banc number := to_number(fa_busc_para ('p_codi_timo_depo_banc'))
  );

  parameter r_parameter;



procedure pp_actu_regI(ii_movi_cuen_codi in number,
                        ii_movi_sucu_codi_orig in number,
                        ii_movi_mone_codi      in number,
                        ii_movi_nume           in number,
                        ii_movi_fech_emis      in date,
                        ii_movi_tasa_mone      in number,
                        ii_movi_obse           in varchar2) is
 begin


   if ii_movi_sucu_codi_orig is null then
     raise_application_error(-20010,'Debe ingresar el codigo de la Sucursal!');
   end if;

   if ii_movi_nume is null then
     raise_application_error(-20010,'Debe ingresar el Numero del Rechazo!');
   end if;

   if ii_movi_fech_emis is null then
     raise_application_error(-20010,'Debe ingresar la Fecha del Rechazo!');
   end if;

   pp_valida_fech(ii_movi_fech_emis);

  -- pp_valida_importes;
  select sum(c011)
    into v_sum_cheq_impo
    from apex_collections
   where collection_name = 'BDATOS_I020016'
     and c012 = 'S';

  if v_sum_cheq_impo is null then
    raise_application_error(-20010,
                            'Debe seleccionar por lo menos un cheque');
  end if;

 -- pp_actualiza_movi;
 begin
   I020016.pp_actualiza_movi(i_movi_cuen_codi      => ii_movi_cuen_codi,
                             i_movi_sucu_codi_orig => ii_movi_sucu_codi_orig,
                             i_movi_mone_codi      => ii_movi_mone_codi,
                             i_movi_nume           => ii_movi_nume,
                             i_movi_fech_emis      => ii_movi_fech_emis,
                             i_movi_tasa_mone      => ii_movi_tasa_mone,
                             i_movi_obse           => ii_movi_obse);

 exception
   when others then
     raise_application_error(-20010,
                             'Error al momento de ingresar en come_movi: ' ||
                             sqlerrm);
 end;


-- pp_actualiza_moco;
begin
  I020016.pp_actualiza_moco(i_movi_codi      => v_movi_codi,
                            i_movi_tasa_mone => ii_movi_tasa_mone);
exception
  when others then
    raise_application_error(-20010,
                            'Error al momento de ingresar en come_mo_co: ' ||
                            sqlerrm);
end;


-- pp_actualiza_moimpo;
begin
  I020016.pp_actualiza_moimpo(i_movi_cuen_codi => ii_movi_cuen_codi,
                              i_movi_fech_emis => ii_movi_fech_emis,
                              i_movi_tasa_mone => ii_movi_tasa_mone);
exception
  when others then
    raise_application_error(-20010,
                            'Error al momento de ingresar en moimpo: ' ||
                            sqlerrm);
end;

-- pp_actualiza_moimpu;
begin
  I020016.pp_actualiza_moimpu(i_movi_tasa_mone => ii_movi_tasa_mone);

exception
  when others then
    raise_application_error(-20010,
                            'Error al momento de ingresar en moimpu: ' ||
                            sqlerrm);
end;

  -- pp_actualiza_cheque_reci;
begin
  I020016.pp_actualiza_cheque_reci(i_movi_fech_emis => ii_movi_fech_emis);
exception
  when others then
    raise_application_error(-20010,
                            'Error al momento de ingresar en cheques circuit: ' ||
                            sqlerrm);
end;

 --  pp_gene_mens;
 begin
  -- Call the procedure
  I020016.pp_gene_mens;
end;


  -- message('Registro Actualizado Satisfactoriamente');

 end pp_actu_regi;



procedure pp_actualiza_movi(i_movi_cuen_codi in number,
                            i_movi_sucu_codi_orig in number,
                            i_movi_mone_codi      in number,
                            i_movi_nume           in number,
                            i_movi_fech_emis      in date,
                            i_movi_tasa_mone      in number,
                            i_movi_obse           in varchar2) is

  v_movi_cuen_codi      number;
  v_movi_timo_codi      number;
  v_movi_clpr_codi      number;
  v_movi_sucu_codi_orig number;
  v_movi_mone_codi      number;
  v_movi_nume           number;
  v_movi_fech_emis      date;
  v_movi_fech_grab      date;
  v_movi_user           char(20);
  v_movi_codi_padr      number;
  v_movi_tasa_mone      number;
  v_movi_tasa_mmee      number;
  v_movi_grav_mmnn      number;
  v_movi_exen_mmnn      number;
  v_movi_iva_mmnn       number;
  v_movi_grav_mmee      number;
  v_movi_exen_mmee      number;
  v_movi_iva_mmee       number;
  v_movi_grav_mone      number;
  v_movi_exen_mone      number;
  v_movi_iva_mone       number;
  v_movi_clpr_desc      char(80);
  v_movi_emit_reci      char(1);
  v_movi_afec_sald      char(1);
  v_movi_empr_codi      number;
  v_movi_obse           varchar2(2000);

begin

  --insertar la cabecera de la extr bancario.................................
begin
  select timo_afec_sald, timo_emit_reci, timo_dbcr
    into v_movi_afec_sald, v_movi_emit_reci, v_movi_dbcr
    from come_tipo_movi
   where timo_codi = p_codi_timo_extr_banc;

exception
  when no_data_found then
    raise_application_error(-20010, 'Tipo de Movimiento inexistente');
  when too_many_rows then
    raise_application_error(-20010, 'Tipo de Movimiento duplicado');
end;

  v_movi_codi           := fa_sec_come_movi;
  v_movi_cuen_codi      := i_movi_cuen_codi;
  v_movi_timo_codi      := p_codi_timo_extr_banc;
  v_movi_clpr_codi      := null;
  v_movi_sucu_codi_orig := i_movi_sucu_codi_orig;
  v_movi_mone_codi      := i_movi_mone_codi;
  v_movi_nume           := i_movi_nume;
  v_movi_fech_emis      := i_movi_fech_emis;

  v_movi_fech_grab      := sysdate;

  v_movi_user           := gen_user;
  v_movi_codi_padr      := null;
  v_movi_tasa_mone      := i_movi_tasa_mone;
  v_movi_tasa_mmee      := 0;
  v_movi_grav_mmnn      := 0;
  v_movi_exen_mmnn      := round((v_sum_cheq_impo *
                                 i_movi_tasa_mone),
                                 p_cant_deci_mmnn);
  v_movi_iva_mmnn       := 0;
  v_movi_grav_mmee      := 0;
  v_movi_exen_mmee      := 0;
  v_movi_iva_mmee       := 0;
  v_movi_grav_mone      := 0;
  v_movi_exen_mone      := v_sum_cheq_impo;
  v_movi_iva_mone       := 0;
  v_movi_clpr_desc      := null;
  v_movi_empr_codi      := null;
  v_movi_obse           := i_movi_obse; --'Rechazo de Cheque/s';

  i020016.pp_insert_come_movi(v_movi_codi,
                      v_movi_cuen_codi,
                      v_movi_timo_codi,
                      v_movi_clpr_codi,
                      v_movi_sucu_codi_orig,
                      v_movi_mone_codi,
                      v_movi_nume,
                      v_movi_fech_emis,
                      v_movi_fech_grab,
                      v_movi_user,
                      v_movi_codi_padr,
                      v_movi_tasa_mone,
                      v_movi_tasa_mmee,
                      v_movi_grav_mmnn,
                      v_movi_exen_mmnn,
                      v_movi_iva_mmnn,
                      v_movi_grav_mmee,
                      v_movi_exen_mmee,
                      v_movi_iva_mmee,
                      v_movi_grav_mone,
                      v_movi_exen_mone,
                      v_movi_iva_mone,
                      v_movi_clpr_desc,
                      v_movi_emit_reci,
                      v_movi_afec_sald,
                      v_movi_dbcr,
                      v_movi_empr_codi,
                      v_movi_obse);

end pp_actualiza_movi;

procedure pp_actualiza_moco(i_movi_codi in number,
                            i_movi_tasa_mone in number) is

  --variables para moco
  v_moco_movi_codi number;
  v_moco_nume_item number;
  v_moco_conc_codi number;
  v_moco_cuco_codi number;
  v_moco_impu_codi number;
  v_moco_impo_mmnn number;
  v_moco_impo_mmee number;
  v_moco_impo_mone number;
  v_moco_dbcr      char(1);

begin

  ----actualizar moco....
  v_moco_movi_codi := i_movi_codi;
  v_moco_nume_item := 0;
  v_moco_conc_codi := p_codi_conc;
  v_moco_dbcr      := 'D';
  v_moco_nume_item := v_moco_nume_item + 1;
  v_moco_cuco_codi := null;
  v_moco_impu_codi := p_codi_impu_exen;
  v_moco_impo_mmnn := round((v_sum_cheq_impo *
                            i_movi_tasa_mone),
                            p_cant_deci_mmnn);
  v_moco_impo_mmee := 0;
  v_moco_impo_mone := v_sum_cheq_impo;

  i020016.pp_insert_movi_conc_deta(v_moco_movi_codi,
                           v_moco_nume_item,
                           v_moco_conc_codi,
                           v_moco_cuco_codi,
                           v_moco_impu_codi,
                           v_moco_impo_mmnn,
                           v_moco_impo_mmee,
                           v_moco_impo_mone,
                           v_moco_dbcr);

end;


--actualizar la tabla moimpo , efectivo, cheques dif, cheques dia, y vuelto (para el caso de las cobranzas)
procedure pp_actualiza_moimpo(i_movi_cuen_codi in number,
                              i_movi_fech_emis in date,
                              i_movi_tasa_mone in number) is

  v_moim_movi_codi number;
  v_moim_nume_item number := 0;
  v_moim_tipo      char(20);
  v_moim_cuen_codi number;
  v_moim_dbcr      char(1);
  v_moim_afec_caja char(1);
  v_moim_fech      date;
  v_moim_impo_mone number;
  v_moim_impo_mmnn number;
  v_moim_cheq_codi number;

v_impo_rrrr number;

cursor c_det is
select c001 chmo_moti_rech,
       c002 cheq_banc_desc,
       c003 cheq_clpr_desc,
       c004 cheq_clpr_codi,
       c005 cheq_serie,
       c006 cheq_esta,
       c007 cheq_nume,
       c008 cheq_codi,
       c009 cheq_fech_venc,
       c010 cheq_fech_emis,
       to_number(c011) cheq_impo_mone
  from apex_collections
 where collection_name = 'BDATOS_I020016'
   and c012 = 'S';

begin


 for i in c_det loop

      v_moim_movi_codi := v_movi_codi;
      v_moim_nume_item := v_moim_nume_item + 1;
      v_moim_tipo      := 'Rech. de Cheq.';
      v_moim_cuen_codi := i_movi_cuen_codi;
      v_moim_dbcr      := v_movi_dbcr;
      v_moim_afec_caja := 'S';
      v_moim_fech      := i_movi_fech_emis;
      v_moim_impo_mone := i.CHEQ_IMPO_MONE;
      v_moim_impo_mmnn := round((i.CHEQ_IMPO_MONE *
                                i_movi_tasa_mone),
                                p_cant_deci_mmnn);
      v_moim_cheq_codi := i.cheq_Codi;

     i020016.pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_cheq_codi);

  v_impo_rrrr := i.CHEQ_IMPO_MONE;
  end loop;
 /*exception
   when others then
     raise_application_error(-20010, 'Esto es el monto '||v_impo_rrrr||' <=');*/
end;



procedure pp_actualiza_moimpu(i_movi_tasa_mone in number) is
begin
  --actualizar moim...
  i020016.pp_insert_come_movi_impu_deta(to_number(p_codi_impu_exen),
                                        v_movi_codi,
                                        round((v_sum_cheq_impo * i_movi_tasa_mone), p_cant_deci_mmnn),
                                        0,
                                        0,
                                        0,
                                        v_sum_cheq_impo,
                                        0);

end;

procedure pp_actualiza_cheque_reci(i_movi_fech_emis in date) is

  v_chmo_movi_codi number;
  v_chmo_cheq_codi number;
  v_chmo_esta_ante char(1);
  v_chmo_cheq_secu number;
  v_chmo_cheq_esta varchar2(1);
  v_chmo_moti_rech varchar2(2000);

cursor c_det is
select c001 chmo_moti_rech,
       c002 cheq_banc_desc,
       c003 cheq_clpr_desc,
       c004 cheq_clpr_codi,
       c005 cheq_serie,
       c006 cheq_esta,
       c007 cheq_nume,
       c008 cheq_codi,
       c009 cheq_fech_venc,
       c010 cheq_fech_emis,
       c011 cheq_impo_mone
  from apex_collections
 where collection_name = 'BDATOS_I020016'
   and c012 = 'S';

begin

  v_chmo_movi_codi := v_movi_codi;
 for i in c_det loop

   v_chmo_moti_rech := i.chmo_moti_rech;
   v_chmo_cheq_codi := i.cheq_codi;
   v_chmo_esta_ante := i.cheq_esta;
   v_chmo_cheq_esta := 'R';

   begin

    select (nvl(max(chmo_cheq_secu), 0) + 1)
      into v_chmo_cheq_secu
      from come_movi_cheq
     where chmo_cheq_codi = i.cheq_codi;

   exception
     when no_data_found then
       v_chmo_cheq_secu := 1;
   end;

   i020016.pp_insert_come_movi_cheq(v_chmo_moti_rech,
                                    v_chmo_movi_codi,
                                    v_chmo_cheq_codi,
                                    v_chmo_esta_ante,
                                    v_chmo_cheq_secu,
                                    v_chmo_cheq_esta);


    update come_cheq
       set cheq_esta      = 'R', --Rechazado
           cheq_fech_rech = i_movi_fech_emis,
           cheq_fech_depo = null
     where cheq_codi = v_chmo_cheq_codi;

  end loop;

end pp_actualiza_cheque_reci;


  procedure pp_valida_fech(p_fech in date) is
    begin

     pa_devu_fech_habi(p_fech_inic,p_fech_fini );

    if p_fech not between p_fech_inic and p_fech_fini then

      raise_application_error(-20010, 'La fecha del movimiento debe estar comprendida entre..' ||
            to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
            to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;

  end;


procedure pp_validar_cheq_nume(i_clpr_codi       in number,
                               i_movi_cheq_nume  in come_cheq.cheq_nume%type,
                               o_cheq_codi       out come_cheq.cheq_codi%type,
                               o_movi_nume_depo  out come_movi.movi_nume%type,
                               o_movi_codi_depo  out come_movi.movi_codi%type) is

begin

  select cheq_codi, movi_nume, movi_codi
    into o_cheq_codi,
         o_movi_nume_depo,
         o_movi_codi_depo
    from come_movi, come_movi_cheq, come_cheq
   where movi_timo_codi = 27
     and (cheq_clpr_codi = i_clpr_codi or i_clpr_codi is null)
     and movi_codi = chmo_movi_codi
     and chmo_cheq_codi = cheq_codi
     and cheq_esta = 'D'
     and chmo_cheq_secu =
         (select max(chmo_cheq_secu)
            from come_movi, come_movi_cheq, come_cheq
           where movi_timo_codi = 27
             and (cheq_clpr_codi = i_clpr_codi or
                 i_clpr_codi is null)
             and movi_codi = chmo_movi_codi
             and chmo_cheq_codi = cheq_codi
             and cheq_esta = 'D'
             and cheq_codi = i_movi_cheq_nume
             /*and i_movi_cheq_nume = cheq_nume*/)
     and cheq_codi = i_movi_cheq_nume
     /*and i_movi_cheq_nume = cheq_nume*/;



exception
  when no_data_found then
    raise_application_error(-20010, 'Nro de Cheque inexistente');
    o_cheq_codi      := null;
  when others then
     raise_application_error(-20010, sqlerrm);
end;


procedure pp_ejecutar_consulta_codi(i_movi_codi_depo in number)is

v_sql varchar2(20000);

begin

 v_sql := '
    select
           chmo_moti_rech,
           banc_desc,
           clpr_desc,
           clpr_codi,
           cheq_serie,
           cheq_esta,
           cheq_nume,
           cheq_codi,
           cheq_fech_depo,
           cheq_fech_emis,
           cheq_impo_mone,
           ''N''
      from come_movi,
           come_movi_impo_deta,
           come_movi_cheq,
           come_cheq,
           come_cuen_banc,
           come_clie_prov,
           come_banc
     where movi_codi = chmo_movi_codi
       and movi_codi = moim_movi_codi
       and chmo_cheq_codi = cheq_codi
       and moim_cuen_codi = cuen_codi(+)
       and banc_codi = cheq_banc_codi(+)
       and cheq_clpr_codi = clpr_codi(+)
       and cheq_esta = ''D'' --depositado.....
       and movi_codi = '||i_movi_codi_depo;


 --insert into come_concat (campo1, otro) values (v_sql, 'prueba');

 if apex_collection.collection_exists(p_collection_name => 'BDATOS_I020016') then
   apex_collection.delete_collection(p_collection_name => 'BDATOS_I020016');
 end if;

 declare
   e_20104 exception;
   pragma exception_init(e_20104, -20104);
 begin
   apex_collection.create_collection_from_query(p_collection_name => 'BDATOS_I020016',
                                                p_query           => v_sql);
 exception
   when e_20104 then
     null;
 end;




exception
  when no_data_found then
    raise_application_error(-20010,'Movimiento Inexistente');
  when too_many_rows then
    raise_application_error(-20010, 'Existen dos movimientos con el mismo Codigo, aviste a su administrador');
    --no debería entrar ak.....

end;



procedure pp_muestra_come_cuen_banc(p_cuen_codi      in number,
                                    p_cuen_desc      out char,
                                    p_cuen_mone_codi out number,
                                    p_banc_codi      out number,
                                    p_banc_desc      out char,
                                    p_cuen_nume      out char) is
begin
  select cuen_desc, cuen_mone_codi, banc_codi, banc_desc, cuen_nume
    into p_cuen_desc,
         p_cuen_mone_codi,
         p_banc_codi,
         p_banc_desc,
         p_cuen_nume
    from come_cuen_banc, come_banc
   where cuen_banc_codi = banc_codi(+)
     and cuen_codi = p_cuen_codi;

exception
  when no_data_found then
    p_cuen_desc := null;
    p_banc_codi := null;
    p_banc_desc := null;
    raise_application_error(-20010, 'Cuenta Bancaria Inexistente');
  when others then
    raise_application_error(-20010, 'Problemas al cargar cuenta bancaria: '||sqlcode);
end;

procedure pp_mostrar_mone(p_mone_codi      in number,
                          p_mone_desc_abre out char,
                          p_mone_cant_deci out char) is
begin
  select mone_desc_abre, mone_cant_deci
    into p_mone_desc_abre, p_mone_cant_deci
    from come_mone
   where mone_codi = p_mone_codi;

exception
  when no_data_found then
    p_mone_desc_abre := null;
    p_mone_cant_deci := null;
    raise_application_error(-20010,'Moneda Inexistente!');
  when others then
    raise_application_error(-20010, 'Problemas al mostrar moneda: '||sqlcode);
end;

procedure pp_busca_tasa_mone(p_movi_fech_emis in date,
                             p_mone_codi      in number,
                             p_mone_coti      out number) is
begin


begin
  select timo_tica_codi
    into p_tica_codi
    from come_tipo_movi
   where timo_codi = p_codi_timo_extr_banc;

exception
  when others then
    p_tica_codi := 1;
end;



  if p_codi_mone_mmnn = p_mone_codi then
    p_mone_coti := 1;
  else
    select coti_tasa
      into p_mone_coti
      from come_coti
     where coti_mone = p_mone_codi
       and coti_fech = p_movi_fech_emis
       and coti_tica_codi = p_tica_codi;
  end if;

exception
  when no_data_found then
    p_mone_coti := null;
   raise_application_error(-20010, 'Cotizaciion Inexistente para la fecha del documento');
  when others then
    raise_application_error(-20010, 'Error al buscar tasa: '||sqlcode);

end;

/*********************************inserciones *************************/
procedure pp_insert_come_movi(p_movi_codi           in number,
                              p_movi_cuen_codi      in number,
                              p_movi_timo_codi      in number,
                              p_movi_clpr_codi      in number,
                              p_movi_sucu_codi_orig in number,
                              p_movi_mone_codi      in number,
                              p_movi_nume           in number,
                              p_movi_fech_emis      in date,
                              p_movi_fech_grab      in date,
                              p_movi_user           in char,
                              p_movi_codi_padr      in number,
                              p_movi_tasa_mone      in number,
                              p_movi_tasa_mmee      in number,
                              p_movi_grav_mmnn      in number,
                              p_movi_exen_mmnn      in number,
                              p_movi_iva_mmnn       in number,
                              p_movi_grav_mmee      in number,
                              p_movi_exen_mmee      in number,
                              p_movi_iva_mmee       in number,
                              p_movi_grav_mone      in number,
                              p_movi_exen_mone      in number,
                              p_movi_iva_mone       in number,
                              p_movi_clpr_desc      in char,
                              p_movi_emit_reci      in char,
                              p_movi_afec_sald      in char,
                              p_movi_dbcr           in char,
                              p_movi_empr_codi      in number,
                              p_movi_obse           in varchar2) is
begin



  insert into come_movi
    (movi_codi,
     movi_cuen_codi,
     movi_timo_codi,
     movi_clpr_codi,
     movi_sucu_codi_orig,
     movi_mone_codi,
     movi_nume,
     movi_fech_emis,
     movi_fech_grab,
     movi_user,
     movi_codi_padr,
     movi_tasa_mone,
     movi_tasa_mmee,
     movi_grav_mmnn,
     movi_exen_mmnn,
     movi_iva_mmnn,
     movi_grav_mmee,
     movi_exen_mmee,
     movi_iva_mmee,
     movi_grav_mone,
     movi_exen_mone,
     movi_iva_mone,
     movi_clpr_desc,
     movi_emit_reci,
     movi_afec_sald,
     movi_dbcr,
     movi_empr_codi,
     movi_obse,
     movi_base)
  values
    (

     p_movi_codi,
     p_movi_cuen_codi,
     p_movi_timo_codi,
     p_movi_clpr_codi,
     p_movi_sucu_codi_orig,
     p_movi_mone_codi,
     p_movi_nume,
     p_movi_fech_emis,
     p_movi_fech_grab,
     p_movi_user,
     p_movi_codi_padr,
     p_movi_tasa_mone,
     p_movi_tasa_mmee,
     p_movi_grav_mmnn,
     p_movi_exen_mmnn,
     p_movi_iva_mmnn,
     p_movi_grav_mmee,
     p_movi_exen_mmee,
     p_movi_iva_mmee,
     p_movi_grav_mone,
     p_movi_exen_mone,
     p_movi_iva_mone,
     p_movi_clpr_desc,
     p_movi_emit_reci,
     p_movi_afec_sald,
     p_movi_dbcr,
     p_movi_empr_codi,
     p_movi_obse,
     p_codi_base);


end;


procedure pp_insert_movi_conc_deta(p_moco_movi_codi number,
                                   p_moco_nume_item number,
                                   p_moco_conc_codi number,
                                   p_moco_cuco_codi number,
                                   p_moco_impu_codi number,
                                   p_moco_impo_mmnn number,
                                   p_moco_impo_mmee number,
                                   p_moco_impo_mone number,
                                   p_moco_dbcr      char) is

begin

  insert into come_movi_conc_deta
    (moco_movi_codi,
     moco_nume_item,
     moco_conc_codi,
     moco_cuco_codi,
     moco_impu_codi,
     moco_impo_mmnn,
     moco_impo_mmee,
     moco_impo_mone,
     moco_dbcr,
     moco_base)
  values
    (p_moco_movi_codi,
     p_moco_nume_item,
     p_moco_conc_codi,
     p_moco_cuco_codi,
     p_moco_impu_codi,
     p_moco_impo_mmnn,
     p_moco_impo_mmee,
     p_moco_impo_mone,
     p_moco_dbcr,
     p_codi_base);

end;
procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi in number,
                                        p_moim_nume_item in number,
                                        p_moim_tipo      in char,
                                        p_moim_cuen_codi in number,
                                        p_moim_dbcr      in char,
                                        p_moim_afec_caja in char,
                                        p_moim_fech      in date,
                                        p_moim_impo_mone in number,
                                        p_moim_impo_mmnn in number,
                                        p_moim_cheq_codi in number) is
begin

  insert into come_movi_impo_deta
    (moim_movi_codi,
     moim_nume_item,
     moim_tipo,
     moim_cuen_codi,
     moim_dbcr,
     moim_afec_caja,
     moim_fech,
     moim_impo_mone,
     moim_impo_mmnn,
     moim_cheq_codi,
     moim_base)
  values
    (

     p_moim_movi_codi,
     p_moim_nume_item,
     p_moim_tipo,
     p_moim_cuen_codi,
     p_moim_dbcr,
     p_moim_afec_caja,
     p_moim_fech,
     p_moim_impo_mone,
     p_moim_impo_mmnn,
     p_moim_cheq_Codi,
     p_codi_base);


end;

procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi in number,
                                        p_moim_movi_codi in number,
                                        p_moim_impo_mmnn in number,
                                        p_moim_impo_mmee in number,
                                        p_moim_impu_mmnn in number,
                                        p_moim_impu_mmee in number,
                                        p_moim_impo_mone in number,
                                        p_moim_impu_mone in number) is
begin
  insert into come_movi_impu_deta
    (moim_impu_codi,
     moim_movi_codi,
     moim_impo_mmnn,
     moim_impo_mmee,
     moim_impu_mmnn,
     moim_impu_mmee,
     moim_impo_mone,
     moim_impu_mone,
     moim_base)
  values
    (

     p_moim_impu_codi,
     p_moim_movi_codi,
     p_moim_impo_mmnn,
     p_moim_impo_mmee,
     p_moim_impu_mmnn,
     p_moim_impu_mmee,
     p_moim_impo_mone,
     p_moim_impu_mone,
     p_codi_base);

end;

procedure pp_insert_come_movi_cheq(p_chmo_moti_rech in varchar2,
                                   p_chmo_movi_codi in number,
                                   p_chmo_cheq_codi in number,
                                   p_chmo_esta_ante in char,
                                   p_chmo_cheq_secu in number,
                                   p_chmo_cheq_esta in varchar2) is

begin

  /*
  raise_application_error(-20010,':: '||
  p_chmo_moti_rech ||';'||
  p_chmo_movi_codi ||';'||
  p_chmo_cheq_codi ||';'||
  p_chmo_esta_ante ||';'||
  p_chmo_cheq_secu ||';'||
  p_chmo_cheq_esta
  );
  */
  --Prueba rechazo cheques apex;  63612101;  2113;  D;  1;R


  insert into come_movi_cheq
    (chmo_moti_rech,
     chmo_movi_codi,
     chmo_cheq_codi,
     chmo_esta_ante,
     chmo_cheq_secu,
     chmo_cheq_esta,
     chmo_base)
  values
    (p_chmo_moti_rech,
     p_chmo_movi_codi,
     p_chmo_cheq_codi,
     p_chmo_esta_ante,
     p_chmo_cheq_secu,
     p_chmo_cheq_esta,
     p_codi_base);

end;


procedure pp_gene_mens is
  v_codi      number;
  v_aux       varchar(400);
  v_user      varchar(60);
  v_pres_nume number;
  v_estado    varchar(15);

  v_clpr_codi number;
  v_clpr_desc varchar(200);

  cursor c_user(p_clpr_codi in number) is
    select u.user_login
      from come_clie_prov cp, come_empl e, segu_user u
     where cp.clpr_empl_codi = e.empl_codi
       and e.empl_codi = u.user_empl_codi
       and cp.clpr_codi = p_clpr_codi;

cursor c_det is
select c001 chmo_moti_rech,
       c002 cheq_banc_desc,
       c003 cheq_clpr_desc,
       c004 cheq_clpr_codi,
       c005 cheq_serie,
       c006 cheq_esta,
       c007 cheq_nume,
       c008 cheq_codi,
       c009 cheq_fech_venc,
       c010 cheq_fech_emis,
       c011 cheq_impo_mone
  from apex_collections
 where collection_name = 'BDATOS_I020016'
   and c012 = 'S';

begin


 for i in c_det loop

      select cp.clpr_codi_alte, cp.clpr_desc
        into v_clpr_codi, v_clpr_desc
        from come_clie_prov cp
       where cp.clpr_codi = i.cheq_clpr_codi;

      for x in c_user(i.cheq_clpr_codi) loop
        v_codi := fa_sec_come_mens_sist;
        v_aux  := 'El Cliente cód. ' || v_clpr_codi || ' ' || v_clpr_desc ||
                  ' cuenta con un cheque rechazado con motivo ' ||
                  i.chmo_moti_rech;

        insert into come_mens_sist
          (mesi_codi,
           mesi_desc,
           mesi_user_dest,
           mesi_user_envi,
           mesi_fech,
           mesi_indi_leid)
        values
          (v_codi, v_aux, x.user_login, gen_user, sysdate, 'N');
      end loop;

  end loop;
end;

  procedure pp_add_obs(i_seq_id in number,
                       i_obs    in varchar2) is

    v_chmo_moti_rech varchar2(2000);
    v_cheq_banc_desc varchar2(100);
    v_cheq_clpr_desc varchar2(100);
    v_cheq_clpr_codi varchar2(100);
    v_cheq_serie     varchar2(100);
    v_cheq_esta      varchar2(100);
    v_cheq_nume      varchar2(100);
    v_cheq_codi      varchar2(100);
    v_cheq_fech_venc varchar2(100);
    v_cheq_fech_emis varchar2(100);
    v_cheq_impo_mone varchar2(100);
    v_checked        varchar2(100);

    e_consulta exception;
    e_actualizar exception;

  begin

    begin

        select c001 chmo_moti_rech,
         c002 cheq_banc_desc,
         c003 cheq_clpr_desc,
         c004 cheq_clpr_codi,
         c005 cheq_serie,
         c006 cheq_esta,
         c007 cheq_nume,
         c008 cheq_codi,
         c009 cheq_fech_venc,
         c010 cheq_fech_emis,
         c011 cheq_impo_mone,
         c012 checked
         into
          v_chmo_moti_rech,
          v_cheq_banc_desc,
          v_cheq_clpr_desc,
          v_cheq_clpr_codi,
          v_cheq_serie,
          v_cheq_esta,
          v_cheq_nume,
          v_cheq_codi,
          v_cheq_fech_venc,
          v_cheq_fech_emis,
          v_cheq_impo_mone,
          v_checked

    from apex_collections det
   where collection_name = 'BDATOS_I020016'
     and det.seq_id = i_seq_id;

    exception
      when others then
        raise e_consulta;
    end;

    begin

      APEX_COLLECTION.UPDATE_MEMBER (
        p_collection_name => 'BDATOS_I020016',
        p_seq  => i_seq_id,
        p_c001 =>  i_obs,
        p_c002 =>  v_cheq_banc_desc,
        p_c003 =>  v_cheq_clpr_desc,
        p_c004 =>  v_cheq_clpr_codi,
        p_c005 =>  v_cheq_serie,
        p_c006 =>  v_cheq_esta,
        p_c007 =>  v_cheq_nume,
        p_c008 =>  v_cheq_codi,
        p_c009 =>  v_cheq_fech_venc,
        p_c010 =>  v_cheq_fech_emis,
        p_c011 =>  v_cheq_impo_mone,
        p_c012 =>  v_checked
        );

    exception
      when others then
        raise e_actualizar;
    end;


  exception
    when e_consulta then
      raise_application_error(-20010,'Error al consultar el registro! ');
    when e_actualizar then
      raise_application_error(-20010,'Error al actualizar el registro! ');
    when others then
      raise_application_error(-20010,'Error al añadir Observacion! '|| sqlerrm);

  end pp_add_obs;

-----------------------------------------------
  procedure pp_ejecutar_consulta_nume(i_movi_nume_depo in number) is



    cursor c_cheq_depo(p_movi_codi in number) is
      select chmo_moti_rech,
             banc_desc,
             clpr_desc,
             clpr_codi,
             cheq_serie,
             cheq_esta,
             cheq_codi,
             cheq_nume,
             cheq_fech_venc,
             cheq_fech_emis,
             cheq_impo_mone
        from come_movi,
             come_movi_cheq,
             come_cheq,
             come_cuen_banc,
             come_clie_prov,
             come_banc
       where movi_codi = chmo_movi_codi(+)
         and chmo_cheq_codi = cheq_codi(+)
         and movi_cuen_codi = cuen_codi(+)
         and cheq_banc_codi = banc_codi(+)
         and cheq_clpr_codi = clpr_codi(+)
         and cheq_esta = 'D' --depositado.....
         and movi_codi = p_movi_codi;


      v_cheq_codi number;

  begin

    bsel.movi_nume_depo := i_movi_nume_depo;

    select movi_nume,
           movi_codi,
           to_char(movi_fech_emis, 'dd/mm/yyyy'),
           moim_cuen_codi,
           movi_mone_codi
      into bsel.movi_nume_depo,
           bsel.movi_codi_depo,
           bsel.movi_fech_depo,
           bsel.movi_cuen_codi,
           bsel.movi_mone_codi
      from come_movi, come_movi_impo_deta
     where movi_codi = moim_movi_codi
       and moim_nume_item = 1
       and movi_nume = bsel.movi_nume_depo
       and movi_timo_codi = parameter.p_codi_timo_depo_banc;

    /*
      pl_muestra_come_cuen_banc(:bsel.movi_cuen_codi,
                                :bsel.movi_cuen_desc,
                                :bsel.movi_mone_codi,
                                :bsel.movi_banc_codi,
                                :bsel.movi_banc_desc,
                                :bsel.movi_cuen_nume);

      pp_mostrar_mone(:bsel.movi_mone_codi,
                      :bsel.movi_mone_desc_abre,
                      :bsel.movi_mone_cant_deci);
      pp_busca_tasa_mone(:bsel.movi_mone_codi,
                         :parameter.p_Tica_codi,
                         :bsel.movi_tasa_mone);
    */

    if apex_collection.collection_exists(p_collection_name => 'BDATOS_I020016') then
      apex_collection.truncate_collection(p_collection_name => 'BDATOS_I020016');
    else
      apex_collection.create_collection(p_collection_name => 'BDATOS_I020016');
    end if;

    for x in c_cheq_depo(bsel.movi_codi_depo) loop



      apex_collection.add_member(p_collection_name => 'BDATOS_I020016',
                                 p_c001            => x.chmo_moti_rech,
                                 p_c002            => x.banc_desc,
                                 p_c003            => x.clpr_desc,
                                 p_c004            => x.clpr_codi,
                                 p_c005            => x.cheq_serie,
                                 p_c006            => x.cheq_esta,
                                 p_c007            => x.cheq_nume,
                                 p_c008            => x.cheq_codi,
                                 p_c009            => x.cheq_fech_venc,
                                 p_c010            => x.cheq_fech_emis,
                                 p_c011            => x.cheq_impo_mone);

       v_cheq_codi      := x.cheq_codi;

    end loop;

    if v_cheq_codi is null then
      raise_application_error(-20010, 'El deposito no contiene ningún cheque');
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Movimiento Inexistente');
    when too_many_rows then
      raise_application_error(-20010,'Existen dos movimientos con el mismo Codigo, aviste a su administrador');
      --no debería entrar ak.....
  end pp_ejecutar_consulta_nume;

-----------------------------------------------
  procedure pp_validar_movi_depo(i_movi_codi_depo in number,
                                  i_movi_nume_depo in number,
                                  o_param out number) is
    salir exception;
    v_nume varchar2(200);
    v_cant number := 0;

  begin

    bsel.movi_codi_depo := i_movi_codi_depo;
    bsel.movi_nume_depo := i_movi_nume_depo;

    if bsel.movi_codi_depo is not null then
      pp_ejecutar_consulta_codi(bsel.movi_codi_depo);
    else

      v_nume := bsel.movi_nume_depo;
      --set_item_property('bsel.movi_nume_depo', lov_name, 'lov_movi_depo');
      
      --raise_application_error(-20010, 'v_nume: '||v_nume);
      
      begin
        select count(*)
          into v_cant
          from come_movi
         where movi_nume = v_nume
           and movi_timo_codi = 27;

      end;

      if v_cant > 1 then
        --si existe mas de una factura con el mismo nro
        bsel.movi_nume_depo := v_nume; --para que muestre la lista de acuerdo al nuevo string
        bsel.movi_codi_depo := null; --para ver si se acepto un valor o no despues del list_values
        --list_values;

        if bsel.movi_codi_depo is not null then
          pp_ejecutar_consulta_codi(bsel.movi_codi_depo);
        else

          select distinct movi_codi--movi_nume, movi_fech_emis, cheq_nume,
          into bsel.movi_codi_depo
          from come_movi, come_movi_cheq, come_cheq
          where movi_timo_codi = 27
          and movi_codi = chmo_movi_codi
          and chmo_cheq_codi = cheq_codi
          and cheq_esta = 'D'
          and movi_nume = v_nume
          group by movi_nume, movi_fech_emis, movi_codi, cheq_nume;

          pp_ejecutar_consulta_codi(bsel.movi_codi_depo);


        end if;

      elsif v_cant = 1 then
        pp_ejecutar_consulta_nume(bsel.movi_nume_depo);

      elsif v_cant = 0 then
        raise_application_error(-20010, 'Deposito Bancario Inexistente');
      end if;
    end if;

   o_param := parameter.p_codi_timo_depo_banc;

  exception
    when salir then
      null;

  end pp_validar_movi_depo;

-----------------------------------------------





end I020016;
