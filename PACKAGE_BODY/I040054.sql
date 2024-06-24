
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I040054" is


procedure pp_busca_perf_codi ( p_perf_desc    out varchar2) is

begin    
             
  select perf_codi||'- '||perf_desc
  into  p_perf_desc
  from   rrhh_perf p, segu_user u
  where  p.perf_codi = u.user_perf_codi
  and u.user_login = gen_user;
  
Exception
  when no_data_found then
    null;
 
end pp_busca_perf_codi;



procedure pp_llamar_reporte(p_perfil              in varchar2,
                            p_empl_codi           in number,
                            p_sucu_codi           in number,
                            p_emde_codi           in number,
                            p_emse_codi           in number,
                            p_tiem_codi           in number,
                            p_empl_fech_ingr_desd in date,
                            p_empl_fech_ingr_hast in date,
                            p_empl_fech_baja_hast in date,
                            p_empl_fech_baja_desd in date,
                            p_empl_esta in varchar2,
                            p_empl_tipo_empl      in varchar2,
                            p_salario             in varchar2,
                            p_session             in varchar2) is
                            
v_where varchar2(2000);
v_sql   varchar2(30000);                           

v_nombre       varchar2(50);
v_parametros   clob;
v_contenedores clob;

v_proveedor    varchar2(100);    
v_esta_desc    varchar2(100);
v_empleado varchar2(100);
v_sucursal varchar2(100);
v_departamento  varchar2(100);
v_seccion       varchar2(100);
v_cargo         varchar2(100);
v_perfil        varchar2(100);     
v_user          varchar2(20):= gen_user;              
begin
  --raise_application_error(-20001,'da');

  if p_empl_codi is not null then
    
    select a.empl_codi_alte || '  ' || a.empl_desc
      into v_empleado
      from come_empl a
     where a.empl_codi = p_empl_codi;
  else
   v_empleado :='Todos los Empleados' ;   
  end if;

  if p_sucu_codi is not null then
  select s.sucu_codi||'  '|| sucu_desc
    into v_sucursal
    from come_sucu s
    where s.sucu_codi = p_sucu_codi;
  
  else 
    v_sucursal  := 'Todas las Sucursales';
  end if;

  if p_emde_codi is not null then
 select emde_codi || '  ' || emde_desc
    into v_departamento
    from come_empr_dept
   where emde_codi = p_emde_codi;
   else 
     v_departamento  :='Todos los Departamentos';
  end if;

  if p_emse_codi is not null then
         select emse_codi || ' ' || emse_desc
          into v_seccion
          from come_empr_secc
         where emse_codi = p_emse_codi;
   else
      
    v_seccion  := 'Todas las Secciones';
  end if;

  if p_tiem_codi is not null then
         
  select tiem_codi||' '||tiem_desc
  into   v_cargo
  from   come_tipo_empl
  where  tiem_codi = p_tiem_codi;  
           
  else
    v_cargo  := 'Todos los cargos';            
  end if;

 

  if p_empl_esta = 'T' then
    v_esta_desc := 'Todos los Estados';
  elsif p_empl_esta = 'A' then
    v_esta_desc := 'Activo';
  elsif p_empl_esta = 'I' then
    v_esta_desc := 'Inactivo';
  end if;


     
   V_CONTENEDORES :='p_session:p_empleado:p_sucursal:p_departamento:p_seccion:p_cargo:p_estado:p_ingr_desde:p_ingre_hasta:p_baja_desd:p_baja_hast:p_perfil:p_salario';
   V_PARAMETROS :=p_session||':'||v_empleado||':'||v_sucursal||':'||v_departamento||':'||v_seccion||':'||v_cargo||':'||v_esta_desc||':'||p_empl_fech_ingr_desd||':'||p_empl_fech_ingr_hast||':'||p_empl_fech_baja_hast||':'||p_empl_fech_baja_desd||':'|| replace(p_perfil,'-',' ')||':'||p_salario;

 


    delete from come_parametros_report where usuario = v_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, v_user, 'I040054', 'pdf', v_contenedores);           

end pp_llamar_reporte;


procedure pp_consultar(
                            
                            p_empl_codi           in number,
                            p_sucu_codi           in number,
                            p_emde_codi           in number,
                            p_emse_codi           in number,
                            p_tiem_codi           in number,
                            p_empl_fech_ingr_desd in date,
                            p_empl_fech_ingr_hast in date,
                            p_empl_fech_baja_hast in date,
                            p_empl_fech_baja_desd in date,
                            p_empl_esta in varchar2,
                            p_empl_tipo_empl      in varchar2,
                            p_salario             in varchar2,
                            p_session             in varchar2) is
                            
v_where varchar2(2000);
v_sql   varchar2(30000);                           

v_nombre       varchar2(50);
v_parametros   clob;
v_contenedores clob;

v_proveedor    varchar2(100);    
v_esta_desc    varchar2(100);
v_empleado varchar2(100);
v_sucursal varchar2(100);
v_departamento  varchar2(100);
v_seccion       varchar2(100);
v_cargo         varchar2(100);
v_perfil        varchar2(100);     
v_user          varchar2(20):= gen_user;              
begin
  

  if p_empl_codi is not null then
    v_where := v_where || ' and e.empl_codi =' || to_char(p_empl_codi) || '  ';
    
    
    select a.empl_codi_alte || '  ' || a.empl_desc
      into v_empleado
      from come_empl a
     where a.empl_codi = p_empl_codi;
  else
   v_empleado :='Todos los Empleados' ;   
  end if;

  if p_sucu_codi is not null then
    v_where := v_where || ' and e.empl_sucu_codi =' || to_char(p_sucu_codi) || '  ';
   
   select s.sucu_codi||'  '|| sucu_desc
    into v_sucursal
    from come_sucu s
    where s.sucu_codi = p_sucu_codi;
  
  else 
    v_sucursal  := 'Todas las Sucursales';
  end if;

  if p_emde_codi is not null then
    v_where := v_where || ' and d.emde_codi =' || to_char(p_emde_codi) || '  ';
  select emde_codi || '  ' || emde_desc
    into v_departamento
    from come_empr_dept
   where emde_codi = p_emde_codi;
   else 
     v_departamento  :='Todos los Departamentos';
  end if;

  if p_emse_codi is not null then
    v_where := v_where || ' and s.emse_codi =' || to_char(p_emse_codi) || '  ';
        select emse_codi || ' ' || emse_desc
          into v_seccion
          from come_empr_secc
         where emse_codi = p_emse_codi;
   else
      
    v_seccion  := 'Todas las Secciones';
  end if;

  if p_tiem_codi is not null then
/*    v_where := v_where ||
               ' and e.empl_codi in (select  te.emti_empl_codi from come_empl_tiem te where te.emti_tiem_codi =' ||
               to_char(p_tiem_codi) || ')  ';
               
  select tiem_codi||' '||tiem_desc
  into   v_cargo
  from   come_tipo_empl
  where  tiem_codi = p_tiem_codi;  */
           v_where := v_where || ' and empl_val_cargo =' || to_char(p_tiem_codi) || '  ';              

      select dom_val_minimo||' '||t.dom_descrip
      into v_cargo
      from come_dominio t
      where t.dom_param = 'TIP_CARGO'
      and dom_val_minimo=   p_tiem_codi;  
  else
    v_cargo  := 'Todos los Cargos';            
  end if;

  if p_empl_fech_ingr_desd is not null then
    v_where := v_where || 'and e.empl_fech_ingr >= ''' ||
               to_char(p_empl_fech_ingr_desd, 'dd-mm-yyyy') || '''';
  end if;

  if p_empl_fech_ingr_hast is not null then
    v_where := v_where || 'and e.empl_fech_ingr <= ''' ||
               to_char(p_empl_fech_ingr_hast, 'dd-mm-yyyy') || '''';
  end if;

  if p_empl_fech_baja_desd is not null then
    v_where := v_where || 'and e.empl_fech_baja >= ''' ||
               to_char(p_empl_fech_baja_desd, 'dd-mm-yyyy') || '''';
  end if;

  if p_empl_fech_baja_hast is not null then
    v_where := v_where || 'and e.empl_fech_baja <= ''' ||
               to_char(p_empl_fech_baja_hast, 'dd-mm-yyyy') || '''';
  end if;

  if nvl(p_empl_esta, 'T') <> 'T' then
    v_where := v_where || ' and e.empl_esta = ' || '''' || (p_empl_esta) || '''';
  end if;

  if p_empl_esta = 'T' then
    v_esta_desc := 'Todos los Estados';
  elsif p_empl_esta = 'A' then
    v_esta_desc := 'Activo';
  elsif p_empl_esta = 'I' then
    v_esta_desc := 'Inactivo';
  end if;

  if p_empl_tipo_empl is not null then
    v_where := v_where || ' and e.empl_tipo_empl = ' || chr(39) ||
               p_empl_tipo_Empl || chr(39) || '  ';
  end if;
  

  
  delete come_tabl_auxi where taax_sess=p_session;
  v_sql  := 'insert into come_tabl_auxi (taax_sess,
                                         taax_user,
                                         taax_c001,
                                         taax_c002,
                                         taax_C003,
                                         taax_c004,
                                         taax_C005,
                                         taax_c006,
                                         taax_C007,
                                         taax_c008,
                                         taax_c009,
                                         taax_c010,
                                         taax_c011,
                                         taax_C012,
                                         taax_c013,
                                         taax_c014,
                                         taax_c015,
                                         taax_c016,
                                         taax_c017,
                                         taax_seq)
  
  
  
              select  distinct  '''||p_session||''',
                     '''||v_user||''' ,
                     e.empl_codi,
                     to_char(ltrim(rtrim(replace(replace(e.empl_cedu_nume,''.'',''''), ''-'', '''')))) ci,
                     e.empl_codi_alte,
                     e.empl_desc,
                     e.empl_dire,
                     e.empl_tele,
                     to_char(e.empl_fech_ingr,''DD/MM/YYYY''),
                     to_char(e.empl_fech_baja,''DD/MM/YYYY''),
                     s.emse_codi,
                     s.emse_desc,
                     d.emde_codi,
                     d.emde_desc,
                     decode(e.empl_esta, ''A'', ''Activo'', ''I'', ''Inactivo'') estado, 
                     (tp.tipe_desc), 
                     to_char(e.empl_sala_actu,''999g999g999g999''), 
                     initcap(do.dom_descrip), 
                     peem_indi,
                    ROWNUM ENPL
                     
              from come_empl e,
                   rrhh_perf_empl pe,
                   segu_user u,
                   come_empr_secc s,
                   come_empr_dept d, 
                   rrhh_tipo_peri tp ,
                   come_dominio do
              where e.empl_emse_codi = s.emse_codi (+)
              and   s.emse_emde_codi = d.emde_codi (+)
              and e.empl_tipe_codi = tp.tipe_codi(+)
              and e.empl_codi = pe.peem_empl_codi
              and u.user_login = '''||v_user||''' 
              and u.user_perf_codi  = pe.peem_perf_codi
              and do.dom_param = e.empl_dom_tip_empl
              and do.dom_val_minimo = e.empl_tipo_empl '
              ||v_where||
              ' order by  to_number(e.empl_codi_alte)';
              
           DBMS_OUTPUT.PUT_LINE(v_sql);
       execute immediate v_sql;
     commit;
          --  RAISE_APPLICATION_ERROR(-20001, 'eRROR');    

end pp_consultar;

end I040054;
