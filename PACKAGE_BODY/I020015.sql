
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020015" is


  p_cant_deci_mmnn      number:= to_number(fa_busc_para ('p_cant_deci_mmnn'));   
  
  p_cant_deci_porc      number:= to_number(fa_busc_para ('p_cant_deci_porc'));   
  p_cant_deci_mmee      number:= to_number(fa_busc_para ('p_cant_deci_mmee'));   
  p_cant_deci_cant      number:= to_number(fa_busc_para ('p_cant_deci_cant'));   
  
  p_codi_mone_mmnn      number:= to_number(fa_busc_para ('p_codi_mone_mmnn'));   
  p_codi_conc           number:= to_number(fa_busc_para ('p_codi_conc_cheq_debi'));     
  p_codi_impu_exen      number:= to_number(fa_busc_para ('p_codi_impu_exen'));   
  p_codi_timo_depo_banc number:= to_number(fa_busc_para ('p_codi_timo_depo_banc'));   
  
  p_codi_clie_espo      number:= to_number(fa_busc_para ('p_codi_clie_espo'));                        
  p_codi_prov_espo      number:= to_number(fa_busc_para ('p_codi_prov_espo'));    
  p_para_inic           varchar2(4000);                    
    
  p_fech_inic           date;
  p_fech_fini           date;
  
  p_codi_base           number:= pack_repl.fa_devu_codi_base;
  p_timo_tica_codi      number;
  
  p_codi_impu_grav10    number:= to_number(fa_busc_para ('p_codi_impu_grav10'));   
  p_codi_impu_grav5     number:= to_number(fa_busc_para ('p_codi_impu_grav5')); 
  v_seq                 number;
  v_erro_codi           number;
  v_erro_desc           varchar2(5000);
  
  v_where               varchar2(15000);
  v_sql                 varchar2(15000);
  v_movi_codi           number;
  v_movi_dbcr           char(1);
  

 procedure pp_actu_movi(ii_movi_cuen_codi      in number,
                        ii_movi_nume           in number,
                        ii_clpr_codi_p         in number,
                        ii_movi_fech_emis      date,
                        ii_sum_cheq_impo       in number,
                        ii_movi_impo_deto_mone in number,
                        ii_movi_cheq_indi_desc in varchar2,
                        ii_reca_cuen_codi      in number,
                        ii_movi_sucu_codi_orig in number,
                        ii_movi_tasa_mone      in number,
                        ii_movi_obse           in varchar2,
                        ii_sode_codi           in number,
                        ii_movi_mone_codi      in number,
                        ii_movi_banc_codi      in number) is
  
v_SUM_CHEQ_IMPO number;
begin
  
  if ii_movi_cheq_indi_desc = 'D' then 
    if ii_clpr_codi_p is null then
      raise_application_error(-20010, 'Debe ingresar el el Codigo del Proveedor'); 
    end if;
    i020015.pp_valida_cuen_prov(i_movi_cuen_codi => ii_movi_cuen_codi,
                                i_clpr_codi_p    => ii_clpr_codi_p);
  end if;
  
    if ii_movi_fech_emis is null then
    raise_application_error(-20001,'Favor agregar la fecha de deposito.!');
    end if;
    
    
    if ii_movi_nume is null then
    raise_application_error(-20001,'Debe ingresar el Numero del deposito.!');
    end if;
    
    
    ---
    select sum(c007) 
   into v_SUM_CHEQ_IMPO 
   from apex_collections
  where collection_name = 'BDATOS'
    and c010 = 'S';
   
   if nvl(v_SUM_CHEQ_IMPO,0) = 0 then
  	raise_application_error(-20001,'Debe seleccionar por lo menos un cheque');
   end if;
   
 
  i020015.pp_vali_fech(ii_movi_fech_emis);  
  i020015.pp_valida_importes(ii_sum_cheq_impo,  ii_movi_impo_deto_mone, ii_movi_cheq_indi_desc);  
  i020015.pp_validar_nume_cuen (ii_movi_cuen_codi, ii_movi_nume);

      begin
      --pp_actualiza_movi
      I020015.pp_actualiza_movi(i_movi_cuen_codi      => ii_movi_cuen_codi,
                                i_movi_impo_deto_mone => ii_movi_impo_deto_mone,
                                i_sum_cheq_impo       => ii_sum_cheq_impo,
                                i_reca_cuen_codi      => ii_reca_cuen_codi,
                                i_clpr_codi           => ii_clpr_codi_p,
                                i_movi_sucu_codi_orig => ii_movi_sucu_codi_orig,
                                i_movi_mone_codi      => ii_movi_mone_codi,
                                i_movi_nume           => ii_movi_nume,
                                i_movi_fech_emis      => ii_movi_fech_emis,
                                i_movi_tasa_mone      => ii_movi_tasa_mone,
                                i_movi_obse           => ii_movi_obse,
                                i_movi_cheq_indi_desc => ii_movi_cheq_indi_desc,
                                i_sode_codi           => ii_sode_codi,
                                o_movi_codi           => v_movi_codi);
  exception 
    when others then 
      raise_application_error(-20010, 'Erro el momento de guardar en come_movi: '||sqlcode);   
   end;



 
  --pp_actualiza_moco;
  begin
  i020015.pp_actualiza_moco(v_movi_codi, ii_movi_impo_deto_mone, ii_sum_cheq_impo, ii_movi_tasa_mone);
  
  exception 
    when others then 
      raise_application_error(-20010, 'Erro el momento de guardar en come_movi_mo22: '||sqlcode);  
  end;
  
  --pp_actualiza_moimpo;
  begin
   I020015.pp_actualiza_moimpo(ii_movi_impo_deto_mone,
                               ii_sum_cheq_impo,
                               ii_movi_cuen_codi,
                               ii_movi_fech_emis,
                               ii_movi_tasa_mone);
    exception 
    when others then 
      raise_application_error(-20010, 'Erro el momento de guardar en come_impo: '||sqlcode);  
   end;

  --pp_actualiza_cheque_reci;
  begin
  I020015.pp_actualiza_cheque_reci(ii_movi_cheq_indi_desc, ii_movi_banc_codi, ii_movi_fech_emis);
  
    exception 
    when others then 
      raise_application_error(-20010, 'Erro el momento de guardar en come_cheq_reci: '||sqlcode);  
  end;
  
  
begin
  
  if ii_sode_codi is not null then
    update come_soli_cheq_desc s
       set s.sode_esta_soli = 'C'
     where s.sode_codi = ii_sode_codi
       and nvl(s.sode_esta_soli, 'P') = 'P';
  end if;

  exception 
    when others then 
      raise_application_error(-20010, 'Erro el momento de modificar solicitud: '||sqlcode);  
  end;
 -- message('Registro Actualizado Satisfactoriamente');

  end pp_actu_movi;

procedure pp_valida_cuen_prov(i_movi_cuen_codi in number,
                              i_clpr_codi_p    in number) is
  --validar que la cuenta seleccionada corresponda a un banco y tenga prooveedor no nulo

  v_indi_caja_banc varchar2(1);
  v_banc_clpr_codi number;
begin

  select c.cuen_indi_caja_banc, banc_clpr_codi
    into v_indi_caja_banc, v_banc_clpr_codi
    from come_cuen_banc c, come_banc b
   where c.cuen_banc_codi = b.banc_codi(+)
        --and c.cuen_indi_caja_banc = 'B'
        ---and b.banc_clpr_codi is not null
     and c.cuen_codi = i_movi_cuen_codi;

  if nvl(v_indi_caja_banc, 'C') <> 'B' then
    raise_application_error(-20010, 'Verifique que la Cuenta seleccionada corresponda a un Banco ');
  end if;

  if v_banc_clpr_codi is null then
    raise_application_error(-20010, 'La entidad bancaria relacionada a la cuenta bancaria no posee un proveedor asignado');
  end if;

  if v_banc_clpr_codi <> nvl(i_clpr_codi_p, -99999) then
    raise_application_error(-20010, 'El proveedor seleccionado no corresponde con el proveedor de la entidad bancaria');
  end if;

exception
  when no_data_found then
    raise_application_error(-20010, 'Cuenta bancaria no encontrada!!');
  
end;

procedure pp_valida_importes(i_sum_cheq_impo       in number,
                             i_movi_impo_deto_mone in number,
                             i_movi_cheq_indi_desc in varchar2) is
begin
  if nvl(i_sum_cheq_impo, 0) = 0 then
    raise_application_error(-20010,'Debe seleccionar por lo menos un cheque');
  end if;

  if nvl(i_movi_impo_deto_mone, 0) <> 0 then
    if i_movi_cheq_indi_desc <> 'D' then
      raise_application_error(-20010,'Si ingresa el Importe Interes Deto,el Deposito debe ser Descontado.');
    end if;
  end if;
end;

procedure pp_validar_nume_cuen (p_cuen_codi in number,
                                p_movi_nume in number)is
v_cant number := 0;
begin
  select count(*)
    into v_cant
    from come_movi m, come_tipo_movi t, come_movi_cheq c
   where m.movi_cuen_codi = p_cuen_codi
     and m.movi_nume = p_movi_nume
     and m.movi_timo_codi = t.timo_codi
     and c.chmo_movi_codi = m.movi_codi
     and t.timo_codi = 27;
  
  if v_cant > 0 then
    raise_application_error(-20010,'La Cuenta Bancaria  ya posee un Deposito con esta numeracion '||p_movi_nume||', favor verifique!');
  end if;
  
  Exception
    when no_data_found then
      v_cant := null;
end;

procedure pp_muestra_tipo_movi(p_timo_codi      in number,
                               p_timo_afec_sald out char,
                               p_timo_emit_reci out char,
                               p_timo_dbcr      out char) is
begin

  select timo_afec_sald, timo_emit_reci, timo_dbcr
    into p_timo_afec_sald, p_timo_emit_reci, p_timo_dbcr
    from come_tipo_movi
   where timo_codi = p_timo_codi;

exception
  when no_data_found then
    p_timo_afec_sald := null;
    p_timo_emit_reci := null;
    p_timo_dbcr      := null;
    raise_application_error(-20010, 'Tipo de Movimiento inexistente..');
  when too_many_rows then
    raise_application_error(-20010, 'Tipo de Movimiento duplicado...');
end;

 procedure pp_inic(o_timo_tica_codi out number) is
 
 begin
   select m.timo_tica_codi,timo_tica_codi
     into p_timo_tica_codi,o_timo_tica_codi
     from come_tipo_movi m
    where m.timo_codi = p_codi_timo_depo_banc;
 
   if p_timo_tica_codi is null then
     raise_application_error(-20010, 'Debe configurar el tipo de cambio para el tipo de movimiento ' ||
           p_codi_timo_depo_banc);
   end if;
 
 begin
   
 select pant_para_inic
   into p_para_inic
   from segu_pant t
  where pant_file = 'I020015'
    and pant_codi = 106; -- Deposito De Cheques Recibidos-Cierre De Caja- 978: ESTE PARAMETRO DEBERA DE CAMBIAR CUANDO SEA EL PROGRAMA 
    
  setitem('P39_PARA_INIC', NVL(p_para_inic, 'X'));
  
 exception 
   when no_data_found then 
     null;
   when others then 
     raise_application_error(-20010, 'Error al momento de obtener parametro de inicio: '||sqlcode);
 
 end;
 
 exception
   when no_data_found then
     raise_application_error(-20010,
                             'El tipo de movimiento configurado como deposito bancario no existe!');
   when others then
     raise_application_error(-20010, sqlerrm);
   
 end pp_inic;
   
   
   
 procedure pp_vali_fech (i_fech_emis in date) is
 
 begin
   pa_devu_fech_habi(p_fech_inic, p_fech_fini);
 
   if i_fech_emis not between p_fech_inic and p_fech_fini then
     raise_application_error(-20010,
                             'La fecha del movimiento debe estar comprendida entre..' ||
                             to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                             to_char(p_fech_fini, 'dd-mm-yyyy'));
   
   end if;
 
 end pp_vali_fech;
 
 

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
    raise_application_error(-20010, 'Erro el momento de mostrar moneda :'||sqlcode);
end;

procedure pp_busca_tasa_mone(i_movi_fech_emis in date, 
                             i_movi_mone_codi in number, 
                             i_timo_tica_codi in number,
                             p_mone_coti      out number) is
begin
  if p_codi_mone_mmnn = i_movi_mone_codi then
    p_mone_coti := 1;
  else
    select coti_tasa
      into p_mone_coti
      from come_coti
     where coti_mone = i_movi_mone_codi
       and coti_fech = i_movi_fech_emis
       and coti_tica_codi = i_timo_tica_codi;
  end if;

exception
  when no_data_found then
    p_mone_coti := null;
    raise_application_error(-20010, 'Cotizacion Inexistente para la fecha del documento');
  when others then
    raise_application_error(-20010, 'Error al momento de cargar Tasa:'||sqlcode);
  
end;


Procedure pp_mues_come_cuen_banc (p_cuen_codi in number, 
                                  p_cuen_desc out char, 
                                  p_cuen_mone_codi out number, 
                                  p_banc_codi out number, 
                                  p_banc_desc out char, 
                                  p_cuen_nume out char) is
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

Exception
  when no_data_found then
     p_cuen_desc  :=null;
     p_banc_codi  :=null;
     p_banc_desc  :=null;
     raise_application_error (-20010, 'Cuenta Bancaria Inexistente');
  when others then
      raise_application_error (-20010, 'error al cargar cuanta bancar Re: '||sqlcode);
end;


procedure pp_carg_soli_cheq_desc (i_movi_mone_codi in number,
                                  i_sode_nume      in number,
                                  o_sode_codi      out come_soli_cheq_desc.sode_codi%type,
                                  o_fech_inic      out come_soli_cheq_desc.sode_fech_venc_inic%type,
                                  o_fech_fini      out come_soli_cheq_desc.sode_fech_venc_fini%type,
                                  o_clpr_codi_alte out number,
                                  o_banc_codi      out number) is
                                   
  cursor c_desc(p_sode_codi in number) is
    select d.deta_nume_item,
           d.deta_cheq_codi,
           d.deta_indi_soli,
           b.banc_desc,
           c.cheq_serie,
           c.cheq_nume,
           c.cheq_fech_emis,
           c.cheq_fech_venc,
           c.cheq_impo_mone,
           cp.clpr_desc,
           c.cheq_esta
      from come_soli_cheq_desc_deta d,
           come_cheq                c,
           come_banc                b,
           come_clie_prov           cp
     where d.deta_cheq_codi = c.cheq_codi
       and c.cheq_banc_codi = b.banc_codi
       and c.cheq_clpr_codi = cp.clpr_codi
       and c.cheq_mone_codi = i_movi_mone_codi
       and d.deta_sode_codi = p_sode_codi
       and d.deta_indi_soli = 'S';

    v_sode_codi      come_soli_cheq_desc.sode_codi%type;
    v_fech_inic      come_soli_cheq_desc.sode_fech_venc_inic%type;
    v_fech_fini      come_soli_cheq_desc.sode_fech_venc_fini%type;
    v_clpr_codi_alte number;
    v_banc_codi      number;

begin
  
  select s.sode_codi,
         to_char(s.sode_fech_venc_inic, 'dd-mm-yyyy'),
         to_char(s.sode_fech_venc_fini, 'dd-mm-yyyy'),
         cp.clpr_codi_alte,
         s.sode_banc_codi
    into v_sode_codi,
         v_fech_inic,
         v_fech_fini,
         v_clpr_codi_alte,
         v_banc_codi
    from come_soli_cheq_desc s, come_clie_prov cp
   where s.sode_clpr_codi = cp.clpr_codi(+)
     and s.sode_nume = i_sode_nume
     and nvl(s.sode_esta_soli, 'P') = 'P';


    o_sode_codi      := v_sode_codi;
    o_fech_inic      := v_fech_inic;
    o_fech_fini      := v_fech_fini;
    o_clpr_codi_alte := v_clpr_codi_alte;
    o_banc_codi      := v_banc_codi;
  
v_sql := ' 
    select b.banc_desc, 
           c.cheq_serie,
           c.cheq_nume,  
           d.deta_cheq_codi,
           c.cheq_fech_emis,
           c.cheq_fech_venc,
           c.cheq_impo_mone,
           cp.clpr_desc,   
           c.cheq_esta, 
           ''N'',
           d.deta_nume_item,
           d.deta_indi_soli                
      from come_soli_cheq_desc_deta d,
           come_cheq                c,
           come_banc                b,
           come_clie_prov           cp
     where d.deta_cheq_codi = c.cheq_codi
       and c.cheq_banc_codi = b.banc_codi
       and c.cheq_clpr_codi = cp.clpr_codi
       and c.cheq_mone_codi = '||i_movi_mone_codi||'
       and d.deta_sode_codi = '||v_sode_codi||'
       and d.deta_indi_soli = ''S''';  
   
 insert into come_concat (campo1, otro) values (v_sql, 'LA COSA SE PUSO SERIA 2');
 
 if apex_collection.collection_exists(p_collection_name => 'BDATOS') then
   apex_collection.delete_collection(p_collection_name => 'BDATOS');
 end if;
 
 declare
   e_20104 exception;
   pragma exception_init(e_20104, -20104);
 begin
   apex_collection.create_collection_from_query(p_collection_name => 'BDATOS',
                                                p_query           => v_sql);
 exception
   when e_20104 then
     null;
 end;
 
   
   
   
 /* begin
    pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'), i_taax_user => gen_user);
  end;

  for x in c_desc(v_sode_codi) loop
    
      v_seq := seq_come_tabl_auxi.nextval;
      insert into come_tabl_auxi
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
          taax_c009)
        values (v('APP_SESSION'),
               gen_user,
               v_seq,
               x.banc_desc,
               x.cheq_serie,
               x.cheq_nume,
               x.clpr_desc,
               x.cheq_fech_emis,
               x.cheq_fech_venc,
               x.cheq_impo_mone,
               x.deta_indi_soli,
               x.deta_cheq_codi);
  
  end loop;*/

exception
  when no_data_found then
    raise_application_error(-20010, 'Solicitud inexistente o ya ha sido confirmada');
  when others then
    raise_application_error(-20010,' Error al momento de cargar Solicitud: '|| sqlerrm);
    
end pp_carg_soli_cheq_desc;

procedure pp_ejec_cons(i_movi_mone_codi in number,
                       i_movi_clpr_codi in number,
                       i_banc_codi      in number,
                       i_fech_inic      in date,
                       i_fech_fini      in date,
                       i_cheq_esta      in varchar2,
                       o_resp_codi      out number,
                       o_resp_desc      out varchar2) is

begin     
 
 if i_movi_clpr_codi is not null then 
   v_where :=  ' and cheq_clpr_codi = '||i_movi_clpr_codi;
 end if;
 
 if i_banc_codi is not null then 
   v_where :=  v_where||' and cheq_banc_codi = '||i_banc_codi;
 end if;
 
  if i_banc_codi is not null then 
   v_where :=  v_where||' and cheq_banc_codi = '||i_banc_codi;
 end if;
 
  if i_fech_inic is not null and i_fech_fini is null then 
   v_where :=  v_where||' and cheq_fech_venc >= '''||i_fech_inic||chr(39);
  elsif i_fech_inic is null and i_fech_fini is not null then 
   v_where :=  v_where||' and cheq_fech_venc <= '''||i_fech_fini||chr(39);
  elsif i_fech_inic is not null and i_fech_fini is not null then 
   v_where :=  v_where||' and cheq_fech_venc between '''||i_fech_inic||chr(39)|| ' and ''' ||i_fech_fini||chr(39) ;
  end if;
 
  if i_cheq_esta is null or i_cheq_esta = 'A' then 
    v_where := v_where||' and cheq_esta in  (''I'', ''R'')';
  elsif i_cheq_esta is not null and i_cheq_esta <> 'A' then 
    v_where := v_where||' and cheq_esta = '''||i_cheq_esta||chr(39);
  end if;
 
 v_sql := '  select banc_desc, cheq_serie, cheq_nume, cheq_codi,  cheq_fech_emis, cheq_fech_venc, cheq_impo_mone, clpr_desc, cheq_esta, ''N''
    from come_cheq, come_banc, come_clie_prov
   where cheq_banc_codi = banc_codi
     and cheq_clpr_codi = clpr_codi
     and cheq_tipo = ''R'' 
     and cheq_mone_codi = '||i_movi_mone_codi||' 
     and nvl(cheq_sald_mone, cheq_impo_mone ) > 0 
     '|| v_where;




 --insert into come_concat (campo1, otro) values (v_sql, 'LA COSA SE PUSO SERIA');
 
 if apex_collection.collection_exists(p_collection_name => 'BDATOS') then
   apex_collection.delete_collection(p_collection_name => 'BDATOS');
 end if;
 
 declare
   e_20104 exception;
   pragma exception_init(e_20104, -20104);
 begin
   apex_collection.create_collection_from_query(p_collection_name => 'BDATOS',
                                                p_query           => v_sql);
 exception
   when e_20104 then
     null;
 end;

 exception 
   when others then 
     raise_application_error(-20010, 'Error al momento de ejecutar consulta: '||sqlcode); 
end pp_ejec_cons;

/************ PRE CONFIGURACION INSERCION ************/
procedure pp_actualiza_movi(i_movi_cuen_codi in number,
                            i_movi_impo_deto_mone in number,
                            i_sum_cheq_impo       in number,
                            i_reca_cuen_codi      in number,
                            i_clpr_codi           in number,
                            i_movi_sucu_codi_orig in number,
                            i_movi_mone_codi      in number,
                            i_movi_nume           in number,
                            i_movi_fech_emis      in date,
                            i_movi_tasa_mone      in number,
                            i_movi_obse           in varchar2,
                            i_movi_cheq_indi_desc in varchar2,
                            i_sode_codi           in number,
                            o_movi_codi           out number)      is
                            
  v_movi_cuen_codi      number;
  v_movi_timo_codi      number;
  v_movi_clpr_codi      number;
  v_movi_sucu_codi_orig number;
  v_movi_mone_codi      number;
  v_movi_nume           number;
  v_movi_fech_emis      date;
  v_movi_fech_oper      date;
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
  v_movi_cheq_indi_desc varchar2(1);
  v_movi_impo_deto_mone number;
  v_movi_sode_codi      number;
  v_movi_cuen_codi_reca number;

  v_tota_impo number := 0;

  v_movi_impo_mone_ii   number(20, 4);
  v_movi_impo_mmnn_ii   number(20, 4);
  v_movi_grav10_ii_mone number(20, 4);
  v_movi_grav5_ii_mone  number(20, 4);
  v_movi_grav10_ii_mmnn number(20, 4);
  v_movi_grav5_ii_mmnn  number(20, 4);
  v_movi_grav10_mone    number(20, 4);
  v_movi_grav5_mone     number(20, 4);
  v_movi_grav10_mmnn    number(20, 4);
  v_movi_grav5_mmnn     number(20, 4);
  v_movi_iva10_mone     number(20, 4);
  v_movi_iva5_mone      number(20, 4);
  v_movi_iva10_mmnn     number(20, 4);
  v_movi_iva5_mmnn      number(20, 4);

begin

  --insertar la cabecera del deposito bancario.................................
  i020015.pp_muestra_tipo_movi(p_codi_timo_depo_banc,
                               v_movi_afec_sald,
                               v_movi_emit_reci,
                               v_movi_dbcr);

  if nvl(i_movi_impo_deto_mone, 0) <> 0 then
    v_tota_impo := nvl(i_sum_cheq_impo, 0) - i_movi_impo_deto_mone;
  else
    v_tota_impo := nvl(i_sum_cheq_impo, 0);
  end if;

  v_movi_codi           := fa_sec_come_movi;
  v_movi_cuen_codi      := i_movi_cuen_codi;
  v_movi_cuen_codi_reca := i_reca_cuen_codi;
  v_movi_timo_codi      := p_codi_timo_depo_banc;
  v_movi_clpr_codi      := i_clpr_codi;
  v_movi_sucu_codi_orig := i_movi_sucu_codi_orig;
  v_movi_mone_codi      := i_movi_mone_codi;
  v_movi_nume           := i_movi_nume;
  v_movi_fech_emis      := i_movi_fech_emis;
  v_movi_fech_oper      := i_movi_fech_emis;
  v_movi_fech_grab      := sysdate; --to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');
  v_movi_user           := gen_user;
  v_movi_codi_padr      := null;
  v_movi_tasa_mone      := i_movi_tasa_mone;
  v_movi_tasa_mmee      := 0;
  v_movi_grav_mmnn      := 0;
  v_movi_exen_mmnn      := round((v_tota_impo * i_movi_tasa_mone),
                                 p_cant_deci_mmnn);
  v_movi_iva_mmnn       := 0;
  v_movi_grav_mmee      := 0;
  v_movi_exen_mmee      := 0;
  v_movi_iva_mmee       := 0;
  v_movi_grav_mone      := 0;
  v_movi_exen_mone      := v_tota_impo;
  v_movi_iva_mone       := 0;
  v_movi_clpr_desc      := null;
  v_movi_empr_codi      := null;
  v_movi_obse           := i_movi_obse;
  v_movi_cheq_indi_desc := i_movi_cheq_indi_desc;
  v_movi_impo_deto_mone := i_movi_impo_deto_mone;
  v_movi_sode_codi      := i_sode_codi;

  v_movi_impo_mone_ii   := v_movi_Exen_mone;
  v_movi_impo_mmnn_ii   := v_movi_Exen_mmnn;
  v_movi_grav10_ii_mone := 0;
  v_movi_grav5_ii_mone  := 0;
  v_movi_grav10_ii_mmnn := 0;
  v_movi_grav5_ii_mmnn  := 0;
  v_movi_grav10_mone    := 0;
  v_movi_grav5_mone     := 0;
  v_movi_grav10_mmnn    := 0;
  v_movi_grav5_mmnn     := 0;
  v_movi_iva10_mone     := 0;
  v_movi_iva5_mone      := 0;
  v_movi_iva10_mmnn     := 0;
  v_movi_iva5_mmnn      := 0;

  pp_insert_come_movi(v_movi_codi,
                      v_movi_cuen_codi,
                      v_movi_cuen_codi_reca,
                      v_movi_timo_codi,
                      v_movi_clpr_codi,
                      v_movi_sucu_codi_orig,
                      v_movi_mone_codi,
                      v_movi_nume,
                      v_movi_fech_emis,
                      v_movi_fech_oper,
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
                      v_movi_obse,
                      v_movi_cheq_indi_desc,
                      v_movi_impo_deto_mone,
                      v_movi_sode_codi,
                      
                      v_movi_impo_mone_ii,
                      v_movi_impo_mmnn_ii,
                      v_movi_grav10_ii_mone,
                      v_movi_grav5_ii_mone,
                      v_movi_grav10_ii_mmnn,
                      v_movi_grav5_ii_mmnn,
                      v_movi_grav10_mone,
                      v_movi_grav5_mone,
                      v_movi_grav10_mmnn,
                      v_movi_grav5_mmnn,
                      v_movi_iva10_mone,
                      v_movi_iva5_mone,
                      v_movi_iva10_mmnn,
                      v_movi_iva5_mmnn);

o_movi_codi :=  v_movi_codi;
end;

procedure pp_actualiza_moco(i_movi_codi           in number,
                            i_movi_impo_deto_mone in number,
                            i_sum_cheq_impo       in number,
                            i_movi_tasa_mone      in number)  is

    --variables para moco
    v_moco_movi_codi              number(20);
    v_moco_nume_item              number(10);
    v_moco_conc_codi              number(10);
    v_moco_cuco_codi              number(10);
    v_moco_impu_codi              number(10);
    v_moco_impo_mmnn              number(20,4);
    v_moco_impo_mmee              number(20,4);
    v_moco_impo_mone              number(20,4);
    v_moco_dbcr                   varchar2(1);
    v_moco_base                   number(2);
    v_moco_desc                   varchar2(2000);
    v_moco_tiim_codi              number(10);
    v_moco_indi_fact_serv         varchar2(1);
    v_moco_impo_mone_ii           number(20,4);
    v_moco_cant                   number(20,4);
    v_moco_cant_pulg              number(20,4);
    v_moco_ortr_codi              number(20);
    v_moco_movi_codi_padr         number(20);
    v_moco_nume_item_padr         number(10);
    v_moco_impo_codi              number(20);
    v_moco_ceco_codi              number(20);
    v_moco_orse_codi              number(20);
    v_moco_tran_codi              number(20);
    v_moco_bien_codi              number(20);
    v_moco_tipo_item              varchar2(2);
    v_moco_clpr_codi              number(20);
    v_moco_prod_nume_item         number(20);
    v_moco_guia_nume              number(20);
    v_moco_emse_codi              number(4);
    v_moco_impo_mmnn_ii           number(20,4);
    v_moco_grav10_ii_mone         number(20,4);
    v_moco_grav5_ii_mone          number(20,4);
    v_moco_grav10_ii_mmnn         number(20,4);
    v_moco_grav5_ii_mmnn          number(20,4);
    v_moco_grav10_mone            number(20,4);
    v_moco_grav5_mone             number(20,4);
    v_moco_grav10_mmnn            number(20,4);
    v_moco_grav5_mmnn             number(20,4);
    v_moco_iva10_mone             number(20,4);
    v_moco_iva5_mone              number(20,4);
    v_moco_conc_codi_impu         number(10);
    v_moco_tipo                   varchar2(2);
    v_moco_prod_codi              number(20);
    v_moco_ortr_codi_fact         number(20);
    v_moco_iva10_mmnn             number(20,4);
    v_moco_iva5_mmnn              number(20,4);
    v_moco_sofa_sose_codi         number(20);
    v_moco_sofa_nume_item         number(20);
    v_moco_exen_mone              number(20,4);
    v_moco_exen_mmnn              number(20,4);
    v_moco_empl_codi              number(10);
    v_moco_anex_codi              number(20);
    v_moco_lote_codi              number(10);
    v_moco_bene_codi              number(4);
    v_moco_medi_codi              number(10);
    v_moco_cant_medi              number(20,4);
    v_moco_indi_excl_cont         varchar2(1);
    v_moco_anex_nume_item         number(10);
    v_moco_juri_codi              number(20);
    v_moco_impo_diar_mone         number(20,4);
    v_moco_coib_codi              number(20);
    v_tota_impo                   number;
    
begin

  if nvl(i_movi_impo_deto_mone,0) <> 0 then
    v_tota_impo := nvl(i_sum_cheq_impo,0) - i_movi_impo_deto_mone;
  else
    v_tota_impo := nvl(i_sum_cheq_impo,0);
  end if;
  
 ----actualizar moco.... 
  v_moco_movi_codi := i_movi_codi;
  v_moco_nume_item := 0;
  v_moco_conc_codi := p_codi_conc;
  v_moco_dbcr      := 'D';
  v_moco_nume_item := v_moco_nume_item + 1;       
  v_moco_cuco_codi := null;
  v_moco_impu_codi := p_codi_impu_exen;
  v_moco_impo_mmnn := round((v_tota_impo * i_movi_tasa_mone),p_cant_deci_mmnn);
  v_moco_impo_mmee := 0;
  v_moco_impo_mone := v_tota_impo;

  v_moco_impo_mone_ii := v_moco_impo_mone;
  v_moco_impo_mmnn_ii := v_moco_impo_mmnn;
  
v_moco_grav10_ii_mone         := 0;
v_moco_grav5_ii_mone          := 0;
v_moco_grav10_ii_mmnn         := 0;
v_moco_grav5_ii_mmnn          := 0;
v_moco_grav10_mone            := 0;
v_moco_grav5_mone             := 0;
v_moco_grav10_mmnn            := 0;
v_moco_grav5_mmnn             := 0;
v_moco_iva10_mone             := 0;
v_moco_iva5_mone              := 0;
  

v_moco_iva10_mmnn             := 0;
v_moco_iva5_mmnn              := 0;
v_moco_exen_mone              := v_moco_impo_mone_ii;
v_moco_exen_mmnn              := v_moco_impo_mmnn_ii;


    
  
pp_insert_movi_conc_deta( v_moco_movi_codi              ,
                          v_moco_nume_item              ,
                          v_moco_conc_codi              ,
                          v_moco_cuco_codi              ,
                          v_moco_impu_codi              ,
                          v_moco_impo_mmnn              ,
                          v_moco_impo_mmee              ,
                          v_moco_impo_mone              ,
                          v_moco_dbcr                   ,
                          v_moco_base                   ,
                          v_moco_desc                   ,
                          v_moco_tiim_codi              ,
                          v_moco_indi_fact_serv         ,
                          v_moco_impo_mone_ii           ,
                          v_moco_cant                   ,
                          v_moco_cant_pulg              ,
                          v_moco_ortr_codi              ,
                          v_moco_movi_codi_padr         ,
                          v_moco_nume_item_padr         ,
                          v_moco_impo_codi              ,
                          v_moco_ceco_codi              ,
                          v_moco_orse_codi              ,
                          v_moco_tran_codi              ,
                          v_moco_bien_codi              ,
                          v_moco_tipo_item              ,
                          v_moco_clpr_codi              ,
                          v_moco_prod_nume_item         ,
                          v_moco_guia_nume              ,
                          v_moco_emse_codi              ,
                          v_moco_impo_mmnn_ii           ,
                          v_moco_grav10_ii_mone         ,
                          v_moco_grav5_ii_mone          ,
                          v_moco_grav10_ii_mmnn         ,
                          v_moco_grav5_ii_mmnn          ,
                          v_moco_grav10_mone            ,
                          v_moco_grav5_mone             ,
                          v_moco_grav10_mmnn            ,
                          v_moco_grav5_mmnn             ,
                          v_moco_iva10_mone             ,
                          v_moco_iva5_mone              ,
                          v_moco_conc_codi_impu         ,
                          v_moco_tipo                   ,
                          v_moco_prod_codi              ,
                          v_moco_ortr_codi_fact         ,
                          v_moco_iva10_mmnn             ,
                          v_moco_iva5_mmnn              ,
                          v_moco_sofa_sose_codi         ,
                          v_moco_sofa_nume_item         ,
                          v_moco_exen_mone              ,
                          v_moco_exen_mmnn              ,
                          v_moco_empl_codi              ,
                          v_moco_anex_codi              ,
                          v_moco_lote_codi              ,
                          v_moco_bene_codi              ,
                          v_moco_medi_codi              ,
                          v_moco_cant_medi              ,
                          v_moco_indi_excl_cont         ,
                          v_moco_anex_nume_item         ,
                          v_moco_juri_codi              ,
                          v_moco_impo_diar_mone         ,
                          v_moco_coib_codi                  );      

end;

--actualizar la tabla moimpo , efectivo, cheques dif, cheques dia, y vuelto (para el caso de las cobranzas) 
procedure pp_actualiza_moimpo(i_movi_impo_deto_mone in number,
                              i_sum_cheq_impo       in number,
                              i_movi_cuen_codi      in number,
                              i_movi_fech_emis      in date,
                              i_movi_tasa_mone      in number) is

  v_moim_movi_codi number;
  v_moim_nume_item number := 0;
  v_moim_tipo      char(20);
  v_moim_cuen_codi number;
  v_moim_dbcr      char(1);
  v_moim_afec_caja char(1);
  v_moim_fech      date;
  v_moim_impo_mone number;
  v_moim_impo_mmnn number;
  v_tota_impo      number;
begin

  if nvl(i_movi_impo_deto_mone, 0) <> 0 then
    v_tota_impo := nvl(i_sum_cheq_impo, 0) -  i_movi_impo_deto_mone;
  else
    v_tota_impo := nvl(i_sum_cheq_impo, 0);
  end if;

  v_moim_movi_codi := v_movi_codi;
  v_moim_nume_item := v_moim_nume_item + 1;
  v_moim_tipo      := 'Dep. de Cheq.';
  v_moim_cuen_codi := i_movi_cuen_codi;
  v_moim_dbcr      := v_movi_dbcr;
  v_moim_afec_caja := 'S';
  v_moim_fech      := i_movi_fech_emis;
  v_moim_impo_mone := v_tota_impo;
  v_moim_impo_mmnn := round((v_tota_impo * i_movi_tasa_mone),
                            p_cant_deci_mmnn);

  pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                v_moim_nume_item,
                                v_moim_tipo,
                                v_moim_cuen_codi,
                                v_moim_dbcr,
                                v_moim_afec_caja,
                                v_moim_fech,
                                v_moim_impo_mone,
                                v_moim_impo_mmnn);
end;


procedure pp_actualiza_cheque_reci(i_movi_cheq_indi_desc in varchar2,
                                   i_movi_banc_codi      in number,
                                   i_movi_fech_emis      in date) is

  v_chmo_movi_codi number;
  v_chmo_cheq_codi number;
  v_chmo_esta_ante varchar2(1);
  v_chmo_cheq_secu number;
  v_chmo_cheq_esta varchar2(1);

  v_cheq_indi_desc      varchar2(1);
  v_cheq_banc_codi_desc number;

 cursor c_det is
select c001 Entidad_Bancaria,
       c002 Serie,
       c003 Nro_Cheque,
       c004 cheq_codi,
       c005 fecha_emis,
       c006 fecha_depo,
       C007,
       c008 cliente,
       c009 cheq_esta
  from apex_collections
where collection_name = 'BDATOS'
  and c010 = 'S'; 


begin
  
  if i_movi_cheq_indi_desc = 'D' then
    v_cheq_indi_desc      := 'S';
    v_cheq_banc_codi_desc := i_movi_banc_codi;
  else
    v_cheq_indi_desc := 'N';
  end if;

  v_chmo_movi_codi := v_movi_codi;

 for i in c_det loop
   
      v_chmo_cheq_codi := i.cheq_codi;
      v_chmo_esta_ante := i.cheq_esta;
      v_chmo_cheq_esta := 'D';
        
      select (nvl(max(chmo_cheq_secu), 0) + 1)
        into v_chmo_cheq_secu
        from come_movi_cheq
       where chmo_cheq_codi = i.cheq_codi;
 
    
      pp_insert_come_movi_cheq(v_chmo_movi_codi,
                               v_chmo_cheq_codi,
                               v_chmo_esta_ante,
                               v_chmo_cheq_secu,
                               v_chmo_cheq_esta);
    
      update come_cheq
         set cheq_esta           = 'D', --depositado   , 
             cheq_fech_depo      = i_movi_fech_emis,
             cheq_indi_desc      = v_cheq_indi_desc,
             cheq_banc_codi_desc = v_cheq_banc_codi_desc
       where cheq_codi = v_chmo_cheq_codi;
    
  end loop;

end;

/************** INSERCIONES  *************************/
procedure pp_insert_come_movi(p_movi_codi           in number,
                              p_movi_cuen_codi      in number,
                              p_movi_cuen_codi_reca in number,
                              p_movi_timo_codi      in number,
                              p_movi_clpr_codi      in number,
                              p_movi_sucu_codi_orig in number,
                              p_movi_mone_codi      in number,
                              p_movi_nume           in number,
                              p_movi_fech_emis      in date,
                              p_movi_fech_oper      in date,
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
                              p_movi_obse           in varchar2,
                              p_movi_cheq_indi_desc in varchar2,
                              p_movi_impo_deto_mone in number,
                              p_movi_sode_codi      in number,
                              
                              p_movi_impo_mone_ii   in number,
                              p_movi_impo_mmnn_ii   in number,
                              p_movi_grav10_ii_mone in number,
                              p_movi_grav5_ii_mone  in number,
                              p_movi_grav10_ii_mmnn in number,
                              p_movi_grav5_ii_mmnn  in number,
                              p_movi_grav10_mone    in number,
                              p_movi_grav5_mone     in number,
                              p_movi_grav10_mmnn    in number,
                              p_movi_grav5_mmnn     in number,
                              p_movi_iva10_mone     in number,
                              p_movi_iva5_mone      in number,
                              p_movi_iva10_mmnn     in number,
                              p_movi_iva5_mmnn      in number) is
begin

  insert into come_movi
    (movi_codi,
     movi_cuen_codi,
     movi_cuen_codi_reca,
     movi_timo_codi,
     movi_clpr_codi,
     movi_sucu_codi_orig,
     movi_mone_codi,
     movi_nume,
     movi_fech_emis,
     movi_fech_oper,
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
     movi_cheq_indi_desc,
     movi_impo_deto_mone,
     movi_sode_codi,
     movi_base,
     movi_impo_mone_ii,
     movi_impo_mmnn_ii,
     movi_grav10_ii_mone,
     movi_grav5_ii_mone,
     movi_grav10_ii_mmnn,
     movi_grav5_ii_mmnn,
     movi_grav10_mone,
     movi_grav5_mone,
     movi_grav10_mmnn,
     movi_grav5_mmnn,
     movi_iva10_mone,
     movi_iva5_mone,
     movi_iva10_mmnn,
     movi_iva5_mmnn)
  values
    (p_movi_codi,
     p_movi_cuen_codi,
     p_movi_cuen_codi_reca,
     p_movi_timo_codi,
     p_movi_clpr_codi,
     p_movi_sucu_codi_orig,
     p_movi_mone_codi,
     p_movi_nume,
     p_movi_fech_emis,
     p_movi_fech_oper,
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
     p_movi_cheq_indi_desc,
     p_movi_impo_deto_mone,
     p_movi_sode_codi,
     p_codi_base,
     p_movi_impo_mone_ii,
     p_movi_impo_mmnn_ii,
     p_movi_grav10_ii_mone,
     p_movi_grav5_ii_mone,
     p_movi_grav10_ii_mmnn,
     p_movi_grav5_ii_mmnn,
     p_movi_grav10_mone,
     p_movi_grav5_mone,
     p_movi_grav10_mmnn,
     p_movi_grav5_mmnn,
     p_movi_iva10_mone,
     p_movi_iva5_mone,
     p_movi_iva10_mmnn,
     p_movi_iva5_mmnn);

end;

procedure pp_insert_movi_conc_deta  (
p_moco_movi_codi              in number,
p_moco_nume_item              in number,
p_moco_conc_codi              in number,
p_moco_cuco_codi              in number,
p_moco_impu_codi              in number,
p_moco_impo_mmnn              in number,
p_moco_impo_mmee              in number,
p_moco_impo_mone              in number,
p_moco_dbcr                   in varchar2,
p_moco_base                   in number,
p_moco_desc                   in varchar2,
p_moco_tiim_codi              in number,
p_moco_indi_fact_serv         in varchar2,
p_moco_impo_mone_ii           in number,
p_moco_cant                   in number,
p_moco_cant_pulg              in number,
p_moco_ortr_codi              in number,
p_moco_movi_codi_padr         in number,
p_moco_nume_item_padr         in number,
p_moco_impo_codi              in number,
p_moco_ceco_codi              in number,
p_moco_orse_codi              in number,
p_moco_tran_codi              in number,
p_moco_bien_codi              in number,
p_moco_tipo_item              in varchar2,
p_moco_clpr_codi              in number,
p_moco_prod_nume_item         in number,
p_moco_guia_nume              in number,
p_moco_emse_codi              in number,
p_moco_impo_mmnn_ii           in number,
p_moco_grav10_ii_mone         in number,
p_moco_grav5_ii_mone          in number,
p_moco_grav10_ii_mmnn         in number,
p_moco_grav5_ii_mmnn          in number,
p_moco_grav10_mone            in number,
p_moco_grav5_mone             in number,
p_moco_grav10_mmnn            in number,
p_moco_grav5_mmnn             in number,
p_moco_iva10_mone             in number,
p_moco_iva5_mone              in number,
p_moco_conc_codi_impu         in number,
p_moco_tipo                   in varchar2,
p_moco_prod_codi              in number,
p_moco_ortr_codi_fact         in number,
p_moco_iva10_mmnn             in number,
p_moco_iva5_mmnn              in number,
p_moco_sofa_sose_codi         in number,
p_moco_sofa_nume_item         in number,
p_moco_exen_mone              in number,
p_moco_exen_mmnn              in number,
p_moco_empl_codi              in number,
p_moco_anex_codi              in number,
p_moco_lote_codi              in number,
p_moco_bene_codi              in number,
p_moco_medi_codi              in number,
p_moco_cant_medi              in number,
p_moco_indi_excl_cont         in varchar2,
p_moco_anex_nume_item         in number,
p_moco_juri_codi              in number,
p_moco_impo_diar_mone         in number,
p_moco_coib_codi              in number) is

begin
  insert into come_movi_conc_deta (
moco_movi_codi              ,
moco_nume_item              ,
moco_conc_codi              ,
moco_cuco_codi              ,
moco_impu_codi              ,
moco_impo_mmnn              ,
moco_impo_mmee              ,
moco_impo_mone              ,
moco_dbcr                   ,
moco_base                   ,
moco_desc                   ,
moco_tiim_codi              ,
moco_indi_fact_serv         ,
moco_impo_mone_ii           ,
moco_cant                   ,
moco_cant_pulg              ,
moco_ortr_codi              ,
moco_movi_codi_padr         ,
moco_nume_item_padr         ,
moco_impo_codi              ,
moco_ceco_codi              ,
moco_orse_codi              ,
moco_tran_codi              ,
moco_bien_codi              ,
moco_tipo_item              ,
moco_clpr_codi              ,
moco_prod_nume_item         ,
moco_guia_nume              ,
moco_emse_codi              ,
moco_impo_mmnn_ii           ,
moco_grav10_ii_mone         ,
moco_grav5_ii_mone          ,
moco_grav10_ii_mmnn         ,
moco_grav5_ii_mmnn          ,
moco_grav10_mone            ,
moco_grav5_mone             ,
moco_grav10_mmnn            ,
moco_grav5_mmnn             ,
moco_iva10_mone             ,
moco_iva5_mone              ,
moco_conc_codi_impu         ,
moco_tipo                   ,
moco_prod_codi              ,
moco_ortr_codi_fact         ,
moco_iva10_mmnn             ,
moco_iva5_mmnn              ,
moco_sofa_sose_codi         ,
moco_sofa_nume_item         ,
moco_exen_mone              ,
moco_exen_mmnn              ,
moco_empl_codi              ,
moco_anex_codi              ,
moco_lote_codi              ,
moco_bene_codi              ,
moco_medi_codi              ,
moco_cant_medi              ,
moco_indi_excl_cont         ,
moco_anex_nume_item         ,
moco_juri_codi              ,
moco_impo_diar_mone         ,
moco_coib_codi              ) values (
p_moco_movi_codi              ,
p_moco_nume_item              ,
p_moco_conc_codi              ,
p_moco_cuco_codi              ,
p_moco_impu_codi              ,
p_moco_impo_mmnn              ,
p_moco_impo_mmee              ,
p_moco_impo_mone              ,
p_moco_dbcr                   ,
p_moco_base                   ,
p_moco_desc                   ,
p_moco_tiim_codi              ,
p_moco_indi_fact_serv         ,
p_moco_impo_mone_ii           ,
p_moco_cant                   ,
p_moco_cant_pulg              ,
p_moco_ortr_codi              ,
p_moco_movi_codi_padr         ,
p_moco_nume_item_padr         ,
p_moco_impo_codi              ,
p_moco_ceco_codi              ,
p_moco_orse_codi              ,
p_moco_tran_codi              ,
p_moco_bien_codi              ,
p_moco_tipo_item              ,
p_moco_clpr_codi              ,
p_moco_prod_nume_item         ,
p_moco_guia_nume              ,
p_moco_emse_codi              ,
p_moco_impo_mmnn_ii           ,
p_moco_grav10_ii_mone         ,
p_moco_grav5_ii_mone          ,
p_moco_grav10_ii_mmnn         ,
p_moco_grav5_ii_mmnn          ,
p_moco_grav10_mone            ,
p_moco_grav5_mone             ,
p_moco_grav10_mmnn            ,
p_moco_grav5_mmnn             ,
p_moco_iva10_mone             ,
p_moco_iva5_mone              ,
p_moco_conc_codi_impu         ,
p_moco_tipo                   ,
p_moco_prod_codi              ,
p_moco_ortr_codi_fact         ,
p_moco_iva10_mmnn             ,
p_moco_iva5_mmnn              ,
p_moco_sofa_sose_codi         ,
p_moco_sofa_nume_item         ,
p_moco_exen_mone              ,
p_moco_exen_mmnn              ,
p_moco_empl_codi              ,
p_moco_anex_codi              ,
p_moco_lote_codi              ,
p_moco_bene_codi              ,
p_moco_medi_codi              ,
p_moco_cant_medi              ,
p_moco_indi_excl_cont         ,
p_moco_anex_nume_item         ,
p_moco_juri_codi              ,
p_moco_impo_diar_mone         ,
p_moco_coib_codi              ) ;
  

  
end ;

procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi in number,
                                        p_moim_nume_item in number,
                                        p_moim_tipo      in char,
                                        p_moim_cuen_codi in number,
                                        p_moim_dbcr      in char,
                                        p_moim_afec_caja in char,
                                        p_moim_fech      in date,
                                        p_moim_impo_mone in number,
                                        p_moim_impo_mmnn in number) is
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
     moim_base)
  values
    (p_moim_movi_codi,
     p_moim_nume_item,
     p_moim_tipo,
     p_moim_cuen_codi,
     p_moim_dbcr,
     p_moim_afec_caja,
     p_moim_fech,
     p_moim_impo_mone,
     p_moim_impo_mmnn,
     p_codi_base);

end;

procedure pp_insert_come_movi_cheq(p_chmo_movi_codi in number,
                                   p_chmo_cheq_codi in number,
                                   p_chmo_esta_ante in char,
                                   p_chmo_cheq_secu in number,
                                   p_chmo_cheq_esta in varchar2) is

begin
  insert into come_movi_cheq
    (chmo_movi_codi,
     chmo_cheq_codi,
     chmo_esta_ante,
     chmo_cheq_secu,
     chmo_cheq_esta,
     chmo_base)
  values
    (p_chmo_movi_codi,
     p_chmo_cheq_codi,
     p_chmo_esta_ante,
     p_chmo_cheq_secu,
     p_chmo_cheq_esta,
     p_codi_base);
     
exception
  when others then
    raise_application_error(-20010, 'Erro al insertar come_movi_cheq : '||sqlerrm);
  
end;
end I020015;
