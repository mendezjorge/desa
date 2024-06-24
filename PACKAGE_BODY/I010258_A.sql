
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010258_A" is

  procedure pp_actualizar_tareas(v_ind            in varchar2,
                                 v_jobs_codi      in number,
                                 v_jobs_desc      in varchar2,
                                 v_jobs_inte      in varchar2,
                                 v_jobs_inte_valo in varchar2,
                                 v_jobs_esta      in varchar2,
                                 v_jobs_para      in varchar2,
                                 v_jobs_proc      in varchar2,
                                 v_jobs_prox_ejec in varchar2) is

    v_job       all_jobs.job%type;
    v_what      all_jobs.what%type;
    v_intervalo all_jobs.interval%type;
    v_job_ex    all_jobs.job%type;
    v_next_date date;
    v_operacion varchar2(20);

    v_jobs_prox_ejec_1 varchar2(30);
    v_dia_atra         varchar2(30);
    p_intervalo        varchar2(3000);
    p_job              number;
    v_jobs_desc_1      varchar2(600);
    v_jobs_proc_1      varchar2(900);
    v_cantidad         number;

    --meses
    v_cant_dias   number;
    v_jobs_para_1 varchar2(60);
    x_jobs_codi   number;

  begin
    v_job := v_jobs_codi;
    if substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 12) like 'PA_BLOQ_PERI%' then
      --ok
      v_jobs_desc_1 := 'Timer Bloqueo de periodos';
      v_jobs_proc_1 := 'PA_BLOQ_PERI';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 19) like
          'PA_ACTU_SITU_CLIE%' then
      --ok
      v_jobs_desc_1 := 'Actualiza Situaciones de Clientes';
      v_jobs_proc_1 := 'PA_ACTU_SITU_CLIE';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 23) like
          'PA_ACTU_INDI_TIPO_PRES%' then
      ----ok
      v_jobs_desc_1 := 'Modifica tipo Pedido a Presupuesto';
      v_jobs_proc_1 := 'PA_ACTU_INDI_TIPO_PRES';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 16) like
          'PA_JOB_EXCE_CLIE%' then
      ---ok
      v_jobs_desc_1 := 'Actualiza los clientes en exepcion a N';
      v_jobs_proc_1 := 'PA_JOB_EXCE_CLIE';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 17) like
          'PA_ACTU_RECL_CLIE%' then
      ----ok
      v_jobs_desc_1 := 'Actualiza Reclamadores de Clientes';
      v_jobs_proc_1 := 'PA_ACTU_RECL_CLIE';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 17) like
          'PA_GENE_MENS_CUMP%' then
      ---ok
      v_jobs_desc_1 := 'Genera mensajes de Cumplea?os Clientes';
      v_jobs_proc_1 := 'PA_GENE_MENS_CUMP';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 22) like
          'PA_GENE_MENS_CUMP_EMPL%' then
      ----ok
      v_jobs_desc_1 := 'Genera mensajes de Cumplea?os Empleados';
      v_jobs_proc_1 := 'PA_GENE_MENS_CUMP_EMPL';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 21) like
          'PA_GENE_MENS_CLI_SITU%' then
      ---ok
      v_jobs_desc_1 := 'Generaci?n mensajes de Situaci?n de Cliente';
      v_jobs_proc_1 := 'PA_GENE_MENS_CLI_SITU';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 22) like
          'PA_ACTU_MAXI_PORC_CLIE%' then
      ---ok
      v_jobs_desc_1 := 'Actualizar Porc. Max. de Descuento de Clientes';
      v_jobs_proc_1 := 'PA_ACTU_MAXI_PORC_CLIE';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 22) like
          'PA_ACTU_PROD_EXIS_DIAR%' then
      ---OK
      v_jobs_desc_1 := 'Actualizar existencias exclusivas para Rotacion';
      v_jobs_proc_1 := 'PA_ACTU_PROD_EXIS_DIAR';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 22) like
          'PA_RECA_PROM_DIAS_ATRA%' then
      ---OK
      v_jobs_desc_1 := 'Actualizar promedio de Dias de Atraso de Clientes';
      v_jobs_proc_1 := 'PA_RECA_PROM_DIAS_ATRA';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 17) like
          'PA_ACTU_CALI_CLIE%' then
      ---OK
      v_jobs_desc_1 := 'Actualizar calificacion de Clientes';
      v_jobs_proc_1 := 'PA_ACTU_CALI_CLIE';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 17) like
          'PA_GENE_NOTI_CLIE%' then
      ---OK
      v_jobs_desc_1 := 'Generar Notificaciones de contratos de Lotes';
      v_jobs_proc_1 := 'PA_GENE_NOTI_CLIE';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 22) like
          'PA_GENE_RENO_CONT_AUTO%' then
      ---OK
      v_jobs_desc_1 := 'Genera Renovaci?n de Contrato de Vehiculos';
      v_jobs_proc_1 := 'PA_GENE_RENO_CONT_AUTO';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 17) like
          'PA_GENE_CANC_SENH%' then
      ---OK
      v_jobs_desc_1 := 'Genera Cancelaci?n de Se?a';
      v_jobs_proc_1 := 'PA_GENE_CANC_SENH';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 40) like
          'PACK_ENVI_FACT_RASTREO.PA_BUSC_ENVI_FACT%' then
      ---OK
      v_jobs_desc_1 := 'Enviar Fact. NotaCred. Rec. por Email';
      v_jobs_proc_1 := 'PACK_ENVI_FACT_RASTREO.PA_BUSC_ENVI_FACT';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 31) like
          'PACK_ENVI_SMS.PA_SMS_RECOR_VENC%' then
      ---OK
      v_jobs_desc_1 := 'Recordatorio de vencimientos por SMS';
      v_jobs_proc_1 := 'PACK_ENVI_SMS.PA_SMS_RECOR_VENC';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 30) like
          'PACK_ENVI_SMS.PA_SMS_EMIS_FACT%' then
      ---OK
      v_jobs_desc_1 := 'Notificar emision de facturas por SMS';
      v_jobs_proc_1 := 'PACK_ENVI_SMS.PA_SMS_EMIS_FACT';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 35) like
          'PACK_ENVI_FACT_RASTREO.PA_PROG_MAIL%' then
      ---OK
      v_jobs_desc_1 := 'Enviar Notificaciones de renovaci?n por Email';
      v_jobs_proc_1 := 'PACK_ENVI_FACT_RASTREO.PA_PROG_MAIL';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 45) like
          'PACK_ENVI_FACT_RASTREO.PA_VERI_REBO_PROG_MAIL%' then
      ---OK
      v_jobs_desc_1 := 'Verifica Rebotes de Correo';
      v_jobs_proc_1 := 'PACK_ENVI_FACT_RASTREO.PA_VERI_REBO_PROG_MAIL';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 11) like
          'PA_ACTU_PBI' then
      ---OK
      v_jobs_desc_1 := 'Actualiza Tablas PBI';
      v_jobs_proc_1 := 'PA_ACTU_PBI';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 17) like
          'PA_VERI_VENC_DECO' then
      ---OK
      v_jobs_desc_1 := 'Verifica vence Debitos Comandados';
      v_jobs_proc_1 := 'PA_VERI_VENC_DECO';
    elsif substr(upper(ltrim(rtrim(v_jobs_desc))), 1, 40) like
          'PACK_ENVI_FACT_RASTREO.PA_PROG_NOTA_MAIL%' then
      ---OK
      v_jobs_desc_1 := 'Enviar Notificaciones de vencimiento por Email';
    end if;

    if v_jobs_prox_ejec is null then
      v_jobs_prox_ejec_1 := sysdate;
    else
      v_jobs_prox_ejec_1 := v_jobs_prox_ejec;
    end if;

    --pp_validar_existencia(existe);
    if upper(v_jobs_desc) = upper('pa_actu_indi_tipo_pres') then
      if v_dia_atra is null then
        raise_application_error(-20010,
                                'Debe ingresar los dias pendientes que debe tener el Pedido para realizar los cambios');
      else
        v_what        := upper(v_jobs_desc) || '(' || v_dia_atra || ');';
        v_jobs_para_1 := v_dia_atra;
      end if;
    /*elsif upper(v_jobs_desc) = upper('PA_ACTU_PBI') then
      v_what        := upper(v_jobs_desc) || '(' || chr(39) || 'P' ||
                       chr(39) || ');';
      v_jobs_para_1 := v_dia_atra;*/

    else
      v_what := upper(v_jobs_desc) || ';';
    end if;

    if v_jobs_inte = 'DE' then
      --dia exacto
      if v_jobs_inte_valo not in ('DOMINGO',
                                  'LUNES',
                                  'MARTES',
                                  'MIERCOLES',
                                  'JUEVES',
                                  'VIERNES',
                                  'SABADO') then
        raise_application_error(-20010,
                                'No es un dia de la semana valido!.');
      end if;

      --:parameter.p_inte_valo := v_jobs_inte_valo;
      --pp_hallar_intervalo;
      P_INTERVALO := 'NEXT_DAY(TRUNC(SYSDATE), ' || CHR(39) ||
                     v_jobs_inte_valo || chr(39) || ')';
      --- pl_mm('v_intervalo '||v_intervalo);

    elsif v_jobs_inte = 'M' then
      --meses
      v_cant_dias := round((v_jobs_inte_valo * 30), 0);

      if v_jobs_inte_valo not between 1 and 6 then
        raise_application_error(-20010,
                                'Solo puede introducir valores del 1 al 6!.');
      end if;
      --:parameter.p_inte_valo := v_jobs_inte_valo; ESTE ESTA HABILITADO SEGUN NUEVA FUENTE
      p_intervalo := '' || 'sysdate + ' || to_char(v_cant_dias) || '';

      /*p_intervalo := '' || 'add_months(SYSDATE , ' || v_jobs_inte_valo || ')'; ESTO NO APARECE EN LA NUEVA FUENTE*/

    elsif v_jobs_inte = 'S' then
      --semana
      v_cant_dias := round((v_jobs_inte_valo * 7), 0);
      if v_jobs_inte_valo not between 1 and 4 then
        raise_application_error(-20010,
                                'Solo puede introducir valores del 1 al 4!.');
      end if;
      --:parameter.p_inte_valo := :bmaster.cant_sema;
      p_intervalo := '' || 'SYSDATE + ' || to_char(v_cant_dias) || '';

    elsif v_jobs_inte = 'D' then
      --dias

      if v_jobs_inte_valo not between 1 and 30 then
        raise_application_error(-20010,
                                'Solo puede introducir valores del 1 al 30!.');
      end if;
      --:parameter.p_inte_valo := :bmaster.cant_dia;
      p_intervalo := '' || ' SYSDATE + ' ||
                     to_char(round(v_jobs_inte_valo, 0)) || '';

    elsif v_jobs_inte = 'H' then
      v_cant_dias := round(v_jobs_inte_valo / 24, 4);
      --pl_mm('v_cant_dias '||v_cant_dias);

      if v_jobs_inte_valo not between 1 and 24 then
        raise_application_error(-20010,
                                'Solo puede introducir valores del 1 al 24!.');
      end if;
      --:parameter.p_inte_valo := :bmaster.cant_hora;
      p_intervalo := '' || ' SYSDATE + ' ||
                     replace(ltrim(rtrim(to_char(v_cant_dias, '999G990D990'))),
                             ',',
                             '.') || '';

      --p_intervalo := '' || 'sysdate + ' || '0,33' || '';

    end if;

    v_next_date := to_date(v_jobs_prox_ejec, 'DD/MM/YYYY HH24:MI');
    v_intervalo := p_intervalo;

    begin
      select job
        into p_job
        from user_jobs--dba_jobs j
       where (v_jobs_codi = job or
             (v_jobs_codi is null and
             SUBSTR(LTRIM(RTRIM(UPPER(WHAT))), 1, 50) LIKE
             UPPER(SUBSTR(LTRIM(RTRIM(NVL(v_jobs_desc, 'XX'))), 1, 50)) || '%'))
         AND SCHEMA_USER IN ('SKN', 'APEX_PUBLIC_USER');
    exception
      when others then
        null;
    end;

    v_job_ex := nvl(p_job, 0);

    if v_ind = 'I' then

      select count(*)
        into v_cantidad
        from user_jobs--dba_jobs
       where upper(what) = upper(v_what);
      if v_cantidad > 0 then
        raise_application_error(-20010,
                                'Ya existe una tarea programada igual a la suya.!' /* ||
                                                                v_what*/);
      end if;
      V_OPERACION := 'CREAR';

      if v_next_date is null then
        raise_application_error(-20010,'Debe ingresar una fecha de Prox. Ejecucion');
      end if;
      pa_programador_tareas(v_job,
                            v_job_ex,
                            v_what,
                            v_next_date,
                            v_intervalo,
                            v_operacion);
      select nvl(max(jobs_codi), 0) + 1 into x_jobs_codi from come_jobs;

      insert into come_jobs
        (jobs_codi,
         jobs_desc,
         jobs_inte,
         jobs_inte_valo,
         jobs_esta,
         jobs_para,
         jobs_proc,
         jobs_prox_ejec)
      values
        (v_job,
         v_jobs_desc_1,
         v_jobs_inte,
         v_jobs_inte_valo,
         v_jobs_esta,
         v_jobs_para_1,
         v_jobs_proc_1,
         v_next_date);

    elsif v_ind = 'U' then
      select count(*)
        into v_cantidad
        from user_jobs--dba_jobs
       where replace(upper(what), ';') = replace(upper(v_what), ';')
         and job <> v_job;
      if v_cantidad > 0 then
        raise_application_error(-20010,
                                'Ya existe una tarea programada => ' ||
                                v_jobs_desc_1);
      end if;
      if v_jobs_esta = 'A' then
        V_OPERACION := 'CAMBIAR';
        pa_programador_tareas(v_job,
                              v_job_ex,
                              v_what,
                              v_next_date,
                              v_intervalo,
                              v_operacion);

        update come_jobs
           set jobs_desc      = v_jobs_desc_1,
               jobs_inte      = v_jobs_inte,
               jobs_inte_valo = v_jobs_inte_valo,
               jobs_para      = v_jobs_para_1,
               jobs_proc      = v_jobs_proc_1,
               jobs_prox_ejec = to_date(v_jobs_prox_ejec,
                                        'DD/MM/YYYY HH24:MI')
         where jobs_codi = v_jobs_codi;

      else
        v_operacion := 'BORRAR';
        pa_programador_tareas(v_job,
                              v_job_ex,
                              v_what,
                              v_next_date,
                              v_intervalo,
                              v_operacion);
        delete come_jobs where jobs_codi = v_job_ex;
      end if;
    end if;

  end pp_actualizar_tareas;

  -------------------------------------------------------------------------------------------------------------------------------

  procedure pp_cargar_tareas is

    v_jobs_desc      varchar2(600);
    v_jobs_proc      varchar2(600);
    v_ulti_actu      varchar2(600);
    v_jobs_prox_ejec varchar2(600);
    v_jobs_codi      varchar2(600);
    v_jobs_inte      varchar2(600);
    v_jobs_inte_valo varchar2(600);

    cursor c_dba is
      select db.what      tarea,
             db.LAST_DATE ulti_actu,
             db.NEXT_DATE prox_actu,
             db.job
        from user_jobs db--dba_jobs db
       where SCHEMA_USER in ('SKN', 'APEX_PUBLIC_USER')
       order by job;

    cursor c_jobs(p_codi in number) is
      select jobs_codi, jobs_desc, jobs_inte, jobs_inte_valo
        from come_jobs
       where jobs_codi = p_codi;

    function fi_busca_jobs(p_jobs_codi in number) return boolean is
      v_Count number;
    begin
      select count(*)
        into v_count
        from come_jobs
       where jobs_codi = p_jobs_codi;

      if v_count = 0 then
        return false;
      else
        return true;
      end if;
    end;

  begin
    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name => 'BDATOS');
    for x in c_dba loop
      if x.tarea is not null then
        if substr(upper(ltrim(rtrim(x.tarea))), 1, 12) like 'PA_BLOQ_PERI%' then
          --ok
          v_jobs_desc := 'Timer Bloqueo de periodos';
          v_jobs_proc := 'PA_BLOQ_PERI';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 19) like
              'PA_ACTU_SITU_CLIE%' then
          --ok
          v_jobs_desc := 'Actualiza Situaciones de Clientes';
          v_jobs_proc := 'PA_ACTU_SITU_CLIE';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 23) like
              'PA_ACTU_INDI_TIPO_PRES%' then
          ----ok
          v_jobs_desc := 'Modifica tipo Pedido a Presupuesto';
          v_jobs_proc := 'PA_ACTU_INDI_TIPO_PRES';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 16) like
              'PA_JOB_EXCE_CLIE%' then
          ---ok
          v_jobs_desc := 'Actualiza los clientes en exepcion a N';
          v_jobs_proc := 'PA_JOB_EXCE_CLIE';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 17) like
              'PA_ACTU_RECL_CLIE%' then
          ----ok
          v_jobs_desc := 'Actualiza Reclamadores de Clientes';
          v_jobs_proc := 'PA_ACTU_RECL_CLIE';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 17) like
              'PA_GENE_MENS_CUMP%' then
          ---ok
          v_jobs_desc := 'Genera mensajes de Cumpleanos Clientes';
          v_jobs_proc := 'PA_GENE_MENS_CUMP';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 22) like
              'PA_GENE_MENS_CUMP_EMPL%' then
          ----ok
          v_jobs_desc := 'Genera mensajes de Cumpleanos Empleados';
          v_jobs_proc := 'PA_GENE_MENS_CUMP_EMPL';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 21) like
              'PA_GENE_MENS_CLI_SITU%' then
          ---ok
          v_jobs_desc := 'Generacion mensajes de Situacion de Cliente';
          v_jobs_proc := 'PA_GENE_MENS_CLI_SITU';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 22) like
              'PA_ACTU_MAXI_PORC_CLIE%' then
          ---ok
          v_jobs_desc := 'Actualizar Porc. Max. de Descuento de Clientes';
          v_jobs_proc := 'PA_ACTU_MAXI_PORC_CLIE';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 22) like
              'PA_ACTU_PROD_EXIS_DIAR%' then
          ---OK
          v_jobs_desc := 'Actualizar existencias exclusivas para Rotacion';
          v_jobs_proc := 'PA_ACTU_PROD_EXIS_DIAR';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 22) like
              'PA_RECA_PROM_DIAS_ATRA%' then
          ---OK
          v_jobs_desc := 'Actualizar promedio de Dias de Atraso de Clientes';
          v_jobs_proc := 'PA_RECA_PROM_DIAS_ATRA';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 17) like
              'PA_ACTU_CALI_CLIE%' then
          ---OK
          v_jobs_desc := 'Actualizar calificacion de Clientes';
          v_jobs_proc := 'PA_ACTU_CALI_CLIE';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 17) like
              'PA_GENE_NOTI_CLIE%' then
          ---OK
          v_jobs_desc := 'Generar notificaciones de contratos de lotes';
          v_jobs_proc := 'PA_GENE_NOTI_CLIE';

        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 22) like
              'PA_GENE_RENO_CONT_AUTO%' then
          ---OK
          v_jobs_desc := 'Genera Renovacion de Contrato de Vehiculos';
          v_jobs_proc := 'PA_GENE_RENO_CONT_AUTO';

        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 17) like
              'PA_GENE_CANC_SENH%' then
          ---OK
          v_jobs_desc := 'Genera Cancelacion de Sena';
          v_jobs_proc := 'PA_GENE_CANC_SENH';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 17) like
              'PA_ACTU_CLAS_CLIE%' then
          ---OK
          v_jobs_desc := 'Actualizar Clasificacion de Clientes';
          v_jobs_proc := 'PA_ACTU_CLAS_CLIE';
        elsif substr(upper(ltrim(rtrim(x.tarea))), 1, 22) like
              'PA_APLI_ADEL_NCRE_CLIE%' then
          ---OK
          v_jobs_desc := 'Aplicar Adelantos y Notas de Credito de Clientes';
          v_jobs_proc := 'PA_APLI_ADEL_NCRE_CLIE';

        ELSE
          v_jobs_desc := '*' || x.tarea || '*';
        end if;

        v_ulti_actu      := x.ulti_actu;
        v_jobs_prox_ejec := to_date(x.prox_actu,'DD/MM/YYYY HH24:MI');
        v_jobs_codi      := x.job;

        for z in c_jobs(x.job) loop

          if z.jobs_inte = 'DE' then
            v_jobs_inte      := 'Todos los ';
            v_jobs_inte_valo := z.jobs_inte_valo;

          elsif z.jobs_inte = 'D' then
            v_jobs_inte      := 'Diariamente';
            v_jobs_inte_valo := 'Cada ' || z.jobs_inte_valo || ' Dia/s';
          elsif z.jobs_inte = 'M' then
            v_jobs_inte      := 'Mensualmente';
            v_jobs_inte_valo := 'Cada ' || z.jobs_inte_valo || ' Mes/es';
          elsif z.jobs_inte = 'S' then
            v_jobs_inte      := 'Semanalmente';
            v_jobs_inte_valo := 'Cada ' || z.jobs_inte_valo || ' Semana/s';

          elsif z.jobs_inte = 'H' then
            v_jobs_inte      := 'Por Hora';
            v_jobs_inte_valo := 'Cada ' || z.jobs_inte_valo || ' Hora/s';
          end if;

          apex_collection.add_member(p_collection_name => 'BDATOS',
                                     p_d001            => x.ulti_actu,
                                     p_d002            => x.prox_actu,
                                     p_c001            => v_jobs_desc,
                                     p_c002            => v_jobs_proc,
                                     p_c003            => to_char(to_date(v_ulti_actu, 'DD/MM/YYYY HH24:MI'),'DD/MM/YYYY HH24:MI'),
                                     p_c004            => v_jobs_prox_ejec,
                                     p_c005            => v_jobs_codi,
                                     p_c006            => v_jobs_inte,
                                     p_c007            => v_jobs_inte_valo);

        end loop;

        if not (fi_busca_jobs(x.job)) then
          insert into come_jobs
            (JOBS_CODI,
             JOBS_DESC,
             JOBS_INTE,
             JOBS_INTE_VALO,
             JOBS_ESTA,
             jobs_PARA,
             JOBS_PROC,
             jobs_prox_ejec)
          values
            (x.job,
             v_jobs_desc,
             null,
             null,
             'A',
             NULL,
             v_jobs_proc,
             v_jobs_prox_ejec);
          commit;

        end if;

      end if;
    end loop;
  end pp_cargar_tareas;

end I010258_A;
