
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010437" is

  procedure pp_carga_lado_a(p_codi in number) is
    
     p_esta varchar2(500);
  
   begin
  
  if v('P67_INDI_INAC') = 'N' or v('P67_INDI_INAC') is null then 
     p_esta := 'A';
  else
    p_esta := '''A'', ''I''';  
  end if;
  
  
  delete from come_tabl_auxi where taax_sess = v('APP_SESSION'); 
  
  
    insert into come_tabl_auxi
      (taax_c001, taax_c002, taax_c003, taax_c050, taax_sess, taax_user, taax_seq)
      select empl_codi,
             empl_codi_alte,
             empl_desc,
             'A',
             v('APP_SESSION'),
             gen_user,
             seq_come_tabl_auxi.nextval
        from come_empl
       where empl_codi in (select empl_codi
                             from come_empl
                            where nvl(empl_esta, 'A') in (p_esta)
                           minus
                           select empl_codi
                             from come_empl, rrhh_perf_empl
                            where peem_empl_codi = empl_codi
                              and peem_perf_codi = p_codi);
  
 
  exception 
    when others then 
      raise_application_error(-20010, 'No se puede cargar datos. '||sqlerrm);
  end;

  procedure pp_cargar_lado_b(p_codi in number) is
  begin
  
      insert into come_tabl_auxi
      (taax_c001, taax_c002, taax_c003, taax_c004, taax_c005, taax_c050, taax_sess, taax_user, taax_seq)
      select empl_codi,
             empl_codi_alte,
             empl_desc,
             peem_indi,
             'N',
             'B',
             v('APP_SESSION'),
             gen_user,
             seq_come_tabl_auxi.nextval
        from come_empl, rrhh_perf_empl
       where peem_empl_codi = empl_codi
         and peem_perf_codi = p_codi
         and empl_codi in (/*select empl_codi
                             from come_empl
                            where nvl(empl_esta, 'A') = 'A'
                           minus*/
                           select empl_codi
                             from come_empl, rrhh_perf_empl
                            where peem_empl_codi = empl_codi
                              and peem_perf_codi = p_codi);
  
  
   
  end;


 procedure pp_asociar_desasociar (p_valo in varchar2,  
                                  p_indi in varchar2) is
  
   
   cursor c_valo is
      select regexp_substr(p_valo, '[^:]+', 1, level) rol
        from dual
      connect by regexp_substr(p_valo, '[^:]+', 1, level) is not null;
      
 c       number := 0;
 p_codi  number;
 p_seq   number;
 
 begin
   
  for i in c_valo loop 
    
   if c = 0 then 
     p_codi := i.rol;
     c :=  1;
   else 
     p_seq := i.rol;
   end if;
   
  end loop;
   
 if p_indi = 'N' then   
   
 --MODIFICAMOS LA TABLA TEMPORAL QUE SE USA PARA LA VISUALIZACION
  insert into come_tabl_auxi
    (taax_c001,
     taax_c002,
     taax_c003,
     taax_c004,
     taax_c050,
     taax_sess,
     taax_user,
     taax_seq)
    select empl_codi,
           empl_codi_alte,
           empl_desc,
           'C', -- por defecto agregmos esta opción
           'B',
           v('APP_SESSION'),
           gen_user,
           seq_come_tabl_auxi.nextval
      from come_empl
     where empl_codi = p_codi;
  
  delete from come_tabl_auxi where taax_seq = p_seq;  
  
  --INSERTAMOS EN LA TABLA REAL
    I010437.pp_actualizar_rrhh_perf_empl(p_indi           => 'I',
                                       i_perf_codi      => V('P67_PERF_CODI_ALTE'),
                                       i_peem_empl_codi => p_codi,
                                       i_peem_indi      => null);
  
  
  
 elsif p_indi = 'D' then 
  
  --MODIFICAMOS LA TABLA TEMPORAL QUE SE USA PARA LA VISUALIZACION LADO A  
  insert into come_tabl_auxi
    (taax_c001,
     taax_c002,
     taax_c003,
     taax_c050,
     taax_sess,
     taax_user,
     taax_seq)
    select empl_codi,
           empl_codi_alte,
           empl_desc,
           'A',
           v('APP_SESSION'),
           gen_user,
           seq_come_tabl_auxi.nextval
      from come_empl
     where empl_codi = p_codi; 
 
 delete from come_tabl_auxi where taax_seq = p_seq; 
  
 -- ELIMINAMOS DE LA TABLA REAL
  I010437.pp_actualizar_rrhh_perf_empl(p_indi           => 'D',
                                       i_perf_codi      => V('P67_PERF_CODI_ALTE'),
                                       i_peem_empl_codi => p_codi,
                                       i_peem_indi      => null);
 
 
 end if;
  
  exception
    when others then 
      raise_application_error(-20010, 'Error el momento de asociar 2.1.'); 
  end;
  
  
procedure pp_actualizar_rrhh_perf_empl(p_indi           in char,
                                       i_perf_codi      in number,
                                       i_peem_empl_codi in number,
                                       i_peem_indi      in varchar2) is
  v_indi varchar2(1);

begin
  /*
 
 RAISE_APPLICATION_ERROR(-20010, 
 ' 1. '|| 
 p_indi      ||' 2. '||     
 i_perf_codi      ||' 3. '|| 
 i_peem_empl_codi ||' 4. '|| 
 i_peem_indi      
 
 
 
 
 );*/


  if p_indi = 'I' then
   
  if i_peem_indi is null then
    v_indi := 'C';
  else
    v_indi := i_peem_indi;
  end if;
  
    insert into rrhh_perf_empl
      (peem_perf_codi, peem_empl_codi, peem_indi)
    values
      (i_perf_codi, i_peem_empl_codi, v_indi);
  
  elsif p_indi = 'D' then
  
    delete from rrhh_perf_empl
     where peem_perf_codi = i_perf_codi
       and peem_empl_codi = i_peem_empl_codi;
  
  elsif p_indi = 'A' then
  
    update rrhh_perf_empl
       set peem_indi = i_peem_indi
     where peem_perf_codi = i_perf_codi
       and peem_empl_codi = i_peem_empl_codi;
  
  end if;

/*exception
  when others then
    raise_application_error(-20010,
                            'Error al momento de actualizar RRHH P. ' ||
                            sqlcode);*/
end;
  


end I010437;
