
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."ACTU_RECL_CLIE" is



----------------------------------------------------**

procedure pp_actualizar_cliente (p_redistribuir in varchar2,
                                 p_programa     in varchar2)is 
  
  cursor clients_atras (p_redi in varchar2, p_situ in number) is
  select   a.clpr_codi, a.clpr_cli_situ_codi
  from v_come_clie_sald a
 where dias_atraso > 0
   and clpr_cli_situ_codi = p_situ
   and  (trunc(sysdate) >= trunc(clpr_fech_actu_recl)+30 or clpr_fech_actu_recl is null or p_redi = 'S'  or clpr_empl_codi_recl is null)
   order by clpr_cli_situ_codi;


cursor x_empl (p_nro number, p_situ in number) is
 select orem_empl_codi empleado, nro
  from (
  select orem_empl_codi , rownum nro
      from(
      select orem_empl_codi
        from v_crm_empl_cargo t, come_empl e, come_situ_clie s
       where t.orem_empl_codi = e.empl_codi
         and t.orem_codi = s.situ_dpto_recl
          and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
         and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
         and s.situ_codi=  p_situ
         and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221)
         group by orem_empl_codi))
         where nro =p_nro;
         
         
         
 cursor clientes_permiso is
  select   a.clpr_codi, a.clpr_cli_situ_codi
  from v_come_clie_sald a
 where dias_atraso > 0
  and clpr_empl_codi_recl  in  (select clre_empl_codi 
                                            from come_clie_recl_perm 
                                           where clre_esta ='P'
                                            group by  clre_empl_codi)
   order by clpr_cli_situ_codi;    
       
         
  cursor x_empl_perm (p_nro number) is
      select orem_empl_codi empleado, nro
      from (
      select orem_empl_codi , rownum nro
          from(
          select orem_empl_codi
            from v_crm_empl_cargo t, come_empl e, come_situ_clie s
           where t.orem_empl_codi = e.empl_codi
             and t.orem_codi = s.situ_dpto_recl
             and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
              and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
             and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221)                    
             and orem_empl_codi not in   (select clre_empl_codi 
                                                  from come_clie_recl_perm 
                                                 where clre_esta ='P'
                                                  group by  clre_empl_codi)                            
             group by orem_empl_codi))
             where nro =p_nro;       
 

v_cant_empleados number:= 0;
i number := 0;

v_sysdate date:=sysdate;
v_permiso  number;
v_perm_fec_ini date;
v_perm_fec_fin date;
v_clre_perm_codi number;
v_Cant_actual number;
v_cant_nueva number;
v_redistribuir varchar2(1);
v_situacion number;
begin
  

select count(distinct(t.grsitem_empl ))
 into v_Cant_actual
from come_situ_grup_empl t ;


  
select count(distinct(orem_empl_codi))
  into v_cant_nueva
  from v_crm_empl_cargo t, come_empl e, come_situ_clie s
 where t.orem_empl_codi = e.empl_codi
   and t.orem_codi = s.situ_dpto_recl
   and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
   and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
   and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221)                     
   and orem_empl_codi not in   (select clre_empl_codi 
                                        from come_clie_recl_perm 
                                       where clre_esta ='P'
                                        group by  clre_empl_codi);                       
           

  if v_Cant_actual <> v_cant_nueva then
    v_redistribuir := 'S';
    else
      v_redistribuir := 'N';
  end if;
  
  if p_redistribuir  = 'N' and v_redistribuir = 'S' then
    v_redistribuir := 'S';
    
  elsif p_redistribuir  = 'S' then
    v_redistribuir := 'S';
    
  else
    v_redistribuir :='N';
  end if;




    pa_ejecuta_ddl('ALTER TABLE COME_CLIE_PROV DISABLE ALL TRIGGERS');
  
    if v_redistribuir ='S' then
      delete come_clie_recl_perm s
      where s.clre_esta = 'P';
    end if;

 

  insert into come_actu_recl_audi 
    (clre_fech_actu, clre_fech_prox_actu, clre_user, clre_programa,clre_inde_prog)
  values
    (sysdate, to_date(trunc(sysdate+1)||' 02:30','DD/MM/YYYY HH24:MI'), fp_user, p_programa,'RC');
  


 
  delete from come_situ_grup_clie a
  where a.sigrcl_clie in (  select a.clpr_codi
                                  from v_come_clie_sald a
                                 where dias_atraso > 0
                                   and  (trunc(sysdate) >= trunc(clpr_fech_actu_recl)+30 or clpr_fech_actu_recl is null or v_redistribuir = 'S')
                             );
                                  
  
  delete from come_situ_grup_empl;
  
 if v_redistribuir ='S' then
    delete from come_situ_grup_clie;
    delete from come_situ_grup_empl;
 end if;
 
 
 
 for m in (select situ_codi situacion
               from come_situ_clie t
               where t.situ_dpto_recl is not null
               order by 1 desc) loop
               
    select count(distinct(orem_empl_codi))
      into v_cant_empleados
    from v_crm_empl_cargo t, come_empl e, come_situ_clie s
   where t.orem_empl_codi = e.empl_codi
     and t.orem_codi = s.situ_dpto_recl
     and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
     and situ_codi =m.situacion
     and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
     and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221);
     
     v_situacion := m.situacion;
     i := 0;
                  for y in clients_atras(v_redistribuir , v_situacion)loop
                      i := i + 1;
                      
                     
                               for x in x_empl(i,v_situacion ) loop     
                                  dbms_output.put_line (x.empleado||'/'||y.clpr_codi||'**'||v_situacion);
                                    insert into come_situ_grup_clie
                                      (sigrcl_situ,
                                       sigrcl_grup,
                                       sigrcl_clie,
                                       sigrcl_codi,
                                       sigrcl_fech_grab)
                                    values
                                      (y.clpr_cli_situ_codi,
                                       x.empleado,
                                       y.clpr_codi,
                                       seq_comesitugrupclie.nextval,
                                       v_sysdate);
                                       UPDATE COME_CLIE_PROV
                                      SET CLPR_EMPL_CODI_RECL = x.empleado,
                                           CLPR_FECH_ACTU_RECL = SYSDATE
                                    WHERE CLPR_CODI=  y.clpr_codi;
                                end loop;

                                    if i = v_cant_empleados then
                                      i:= 0;
                                    end if;
                                    
                                    
                     

              end loop;
              
  end loop;            
              for x in (select distinct come_situ_grup_clie.sigrcl_situ,
                                        come_situ_grup_clie.sigrcl_grup
                           from  come_situ_grup_clie
                         order by 1,2) loop
                                   insert into come_situ_grup_empl
                                     (grsitem_situ,
                                      grsitem_grup,
                                      grsitem_empl,
                                      grsitem_codi)
                                   values
                                     (x.sigrcl_situ,
                                      x.sigrcl_grup,
                                      x.sigrcl_grup,
                                      seq_comesitugrupempl.nextval
                                      );
             end loop;
   
     --==actualizamos la ficha de cliente
  /*FOR U IN (SELECT DISTINCT EMPL_CODI
                    FROM V_COME_DIST_SITU_EMPL) LOOP

     UPDATE COME_CLIE_PROV
        SET CLPR_EMPL_CODI_RECL = U.EMPL_CODI,
             CLPR_FECH_ACTU_RECL = SYSDATE
      WHERE CLPR_CODI IN (      SELECT CLPR_CODI
                                  FROM V_COME_DIST_SITU_EMPL
                                 WHERE EMPL_CODI = U.EMPL_CODI
                               ) ;

  END LOOP;*/

  commit;
  
  
     -------------------------------revisamos si el empleado tiene reposo 
     --------le guardamos los empleados que le pertenecen
    
      for p in (select t.orem_empl_codi empl_codigo 
                  from v_crm_empl_cargo t, come_empl e, come_situ_clie s
                 where t.orem_empl_codi = e.empl_codi
                   and t.orem_codi = s.situ_dpto_recl
                   and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
                   and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
                   and (nvl(empl_indi_excl_liqu, 'N') = 'N' or e.empl_codi= 221)
                 group by orem_empl_codi
                ) loop 
         
       begin       
        select count(*),trunc(a.perm_fec_ini), trunc(a.perm_fec_fin)+1, A.PERM_COD--le sumo uno asi se que ese dia tiene que volver a la normalidad
          into v_permiso, v_perm_fec_ini,v_perm_fec_fin, v_clre_perm_codi
          from RRHH_PERMISOS a
         where a.perm_cod_empl = p.empl_codigo
           and trunc(sysdate) between trunc(a.perm_fec_ini) and trunc(a.perm_fec_fin)
           and a.perm_aprob_rrhh = 'A'
           and a.perm_aprob_gcia = 'A'
           group by  trunc(a.perm_fec_ini), trunc(a.perm_fec_fin)+1,A.PERM_COD;
        exception when others then
          
        v_permiso      :=null; 
        v_perm_fec_ini :=null; 
        v_perm_fec_fin :=null; 
        end;
        
            if v_permiso >0  then
              
                insert into come_clie_recl_perm
                  (clre_clie_codi, clre_fech_desd, clre_fech_hast, clre_empl_codi, clre_esta,clre_perm_codi)
                  select clpr_codi, v_perm_fec_ini,v_perm_fec_fin, clpr_empl_codi_recl, 'P',v_clre_perm_codi
                    from come_clie_prov c
                   where c.clpr_indi_clie_prov = 'C'
                     and c.clpr_empl_codi_recl =p.empl_codigo; 
            end if;
        
        
        end loop; 
       ------------------------volvemos a hacer la distribucion 
       
        delete from come_situ_grup_empl;
        
          select count(distinct(orem_empl_codi))
            into v_cant_empleados
            from come_empr_org_empl t, come_empl e, come_situ_clie s
           where t.orem_empl_codi = e.empl_codi
             and t.orem_codi = s.situ_dpto_recl
             and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
             and orem_empl_codi not in   (select clre_empl_codi 
                                                  from come_clie_recl_perm 
                                                 where clre_esta ='P'
                                                  group by  clre_empl_codi)
             and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221);
                
            
           
            for y in clientes_permiso loop
                  i := i + 1;
                  for x in x_empl_perm(i) loop
                    
                  update come_situ_grup_clie ac
                    set ac.sigrcl_grup =  x.empleado
                  where ac.sigrcl_clie =  y.clpr_codi;

                    
                    update come_clie_prov
                     set clpr_empl_codi_recl = x.empleado
                     -- clpr_fech_actu_recl = sysdate
                   where clpr_codi =  y.clpr_codi;
          
                  end loop;
                
                  if i = v_cant_empleados then
                    i := 0;
                  end if;
                
                end loop;
                
                for x in (select distinct come_situ_grup_clie.sigrcl_situ,
                                          come_situ_grup_clie.sigrcl_grup
                            from come_situ_grup_clie
                           order by 1, 2) loop
                  insert into come_situ_grup_empl
                    (grsitem_situ, grsitem_grup, grsitem_empl, grsitem_codi)
                  values
                    (x.sigrcl_situ,
                     x.sigrcl_grup,
                     x.sigrcl_grup,
                     seq_comesitugrupempl.nextval);
                end loop;
               
     
     
      /******************************************************************************************  
  ***************esta parte revisamos si el reposo del reclutador ya termino*****************
  ******************************************************************************************/               
   
  delete from come_situ_grup_empl;
    for x in  (select s.clre_empl_codi reclutador, clre_fech_hast fecha_hasta, clre_perm_codi
                    from come_clie_recl_perm s
                    where s.clre_esta ='P'
                    group by  s.clre_empl_codi,clre_fech_hast,clre_perm_codi ) loop
  
      begin
       select  trunc(v_perm_fec_ini)+1              --le sumo uno asi se que ese dia tiene que volver a la normalidad
          into v_perm_fec_ini
          from RRHH_PERMISOS a
         where PERM_COD = x.clre_perm_codi;
      exception 
       when no_data_found then
         
            v_perm_fec_ini := trunc(sysdate);
       end ;  
           
          if  v_perm_fec_ini = trunc(sysdate) then
  
               update come_clie_prov
                    set clpr_empl_codi_recl = x.reclutador
                  where clpr_codi in (select s.clre_clie_codi
                                        from come_clie_recl_perm s
                                        where s.clre_fech_hast = x.fecha_hasta
                                          and s.clre_empl_codi =x.reclutador
                                        and s.clre_esta = 'P');
                                        
                                        
               update come_situ_grup_clie ttt
                  set ttt.sigrcl_grup = x.reclutador
                where ttt.sigrcl_clie in
                      (select s.clre_clie_codi
                         from come_clie_recl_perm s
                        where s.clre_fech_hast = x.fecha_hasta
                          and s.clre_empl_codi = x.reclutador
                          and s.clre_esta = 'P');
                          
  
              update come_clie_recl_perm s
                 set clre_esta = 'S'
               where s.clre_fech_hast = x.fecha_hasta
                 and s.clre_empl_codi = x.reclutador
                 and s.clre_esta = 'P';
         end if;
  end loop;
  
  
          for x in (select distinct come_situ_grup_clie.sigrcl_situ,
                                              come_situ_grup_clie.sigrcl_grup
                                from come_situ_grup_clie
                               order by 1, 2) loop
                      insert into come_situ_grup_empl
                        (grsitem_situ, grsitem_grup, grsitem_empl, grsitem_codi)
                      values
                        (x.sigrcl_situ,
                         x.sigrcl_grup,
                         x.sigrcl_grup,
                         seq_comesitugrupempl.nextval);
           end loop;
    
  
  

 commit;     
 
  -- pp_act_cambios;       
  pa_ejecuta_ddl('ALTER TABLE COME_CLIE_PROV ENABLE ALL TRIGGERS');
  
  

end pp_actualizar_cliente;



function pp_nombre_cliente(p_cliente in number) return number is
  

v_cliente varchar2(5000);
v_cont number :=0;
begin

select count(*)
into v_cont
  from come_soli_serv_anex a, come_soli_serv b
 where a.anex_sose_codi = b.sose_codi
   and a.anex_auto_nombre is not null
   and sose_clpr_codi = p_cliente;
                 

 return v_cont;

end pp_nombre_cliente;



procedure pp_act_cambios is


  cursor act_cambios(p_situ in number) is(
   select f.clpr_codi, f.clpr_cli_situ_codi
      from come_clie_prov f, v_crm_empl_cargo e, come_situ_clie s
     where f.clpr_empl_codi_recl = e.orem_empl_codi
       and f.clpr_cli_situ_codi = s.situ_codi
      and trunc(sysdate) between e.fecha_desde and e.fecha_hasta
       and f.clpr_indi_clie_prov = 'C'
       and clpr_cli_situ_codi = p_situ
       and situ_dpto_recl is not null
       and e.orem_codi in
           (select t.situ_dpto_recl
              from come_situ_clie t
             where t.situ_dpto_recl is not null)
       /*and case
             when e.orem_codi = s.situ_dpto_recl then
              1
             else
              0
           end = 0*/
           
           union all 
           select f.clpr_codi, f.clpr_cli_situ_codi
      from come_clie_prov f, come_situ_clie s
     where f.clpr_cli_situ_codi = s.situ_codi
       and f.clpr_indi_clie_prov = 'C'
      and clpr_cli_situ_codi =p_situ
       and f.clpr_empl_codi_recl is null
       and situ_dpto_recl is not null);

  cursor x_empl(p_nro number, p_situ in number) is
    select orem_empl_codi empleado, nro
      from (select orem_empl_codi, rownum nro
              from (select orem_empl_codi
                      from v_crm_empl_cargo t,
                           come_empl          e,
                           come_situ_clie     s
                     where t.orem_empl_codi = e.empl_codi
                       and t.orem_codi = s.situ_dpto_recl
                       and (nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
                        and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
                       and s.situ_codi = p_situ
                       and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221)
                     group by orem_empl_codi))
     where nro = p_nro;
     
v_cant_empleados number:= 0;
i number := 0;

v_sysdate date:=sysdate;
v_permiso  number;
v_perm_fec_ini date;
v_perm_fec_fin date;
v_clre_perm_codi number;
v_Cant_actual number;
v_cant_nueva number;
v_redistribuir varchar2(1);
v_situacion number;
begin

    pa_ejecuta_ddl('ALTER TABLE COME_CLIE_PROV DISABLE ALL TRIGGERS');
  for m in (select situ_codi situacion
              from come_situ_clie t
             where t.situ_dpto_recl is not null
           
             order by 1 desc) loop
  
    
  
    select count(distinct(orem_empl_codi))
     into v_cant_empleados
      from v_crm_empl_cargo t, come_empl e, come_situ_clie s
     where t.orem_empl_codi = e.empl_codi
       and t.orem_codi = s.situ_dpto_recl
       and situ_codi = m.situacion
       and trunc(sysdate) between t.fecha_desde and t.fecha_hasta
       and( nvl(e.empl_esta, 'A') = 'A' or e.empl_codi= 221)
       and (nvl(EMPL_INDI_EXCL_LIQU, 'N') = 'N' or e.empl_codi= 221);
    v_situacion := m.situacion;
         i := 0;
          for y in act_cambios(v_situacion) loop
            i := i + 1;
            
          delete from come_situ_grup_clie a where a.sigrcl_clie = y.clpr_codi;
                      for x in x_empl(i, v_situacion) loop
                         dbms_output.put_line (x.empleado||'/'||y.clpr_codi||'/'||y.clpr_cli_situ_codi);
                        insert into come_situ_grup_clie
                          (sigrcl_situ,
                           sigrcl_grup,
                           sigrcl_clie,
                           sigrcl_codi,
                           sigrcl_fech_grab)
                        values
                          (y.clpr_cli_situ_codi,
                           x.empleado,
                           y.clpr_codi,
                           seq_comesitugrupclie.nextval,
                           v_sysdate);
                      
                        UPDATE COME_CLIE_PROV
                           SET CLPR_EMPL_CODI_RECL = x.empleado,
                               CLPR_FECH_ACTU_RECL = SYSDATE
                         WHERE CLPR_CODI = y.clpr_codi;
                      end loop;
          
                      if i = v_cant_empleados then
                        i := 0;
                      end if;
          
          end loop;
  
  end loop;
  
 commit;    
  pa_ejecuta_ddl('ALTER TABLE COME_CLIE_PROV ENABLE ALL TRIGGERS');
end pp_act_cambios;

end actu_recl_clie;
