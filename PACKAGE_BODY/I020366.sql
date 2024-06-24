
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020366" is

  procedure pp_muestra_come_clpr(p_clpr_empr_codi in number,
                                 p_clpr_codi_alte in number,
                                 p_clpr_desc      out varchar2,
                                 p_clpr_codi      out number) is
  begin
    select c.clpr_desc, c.clpr_codi
      into p_clpr_desc, p_clpr_codi
      from come_clie_prov c
     where c.clpr_codi_alte = p_clpr_codi_alte
       and c.clpr_indi_clie_prov = 'C'
       and c.clpr_empr_codi = p_clpr_empr_codi;
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      p_clpr_codi := null;
      raise_application_error(-20001, 'Cliente inexistente!');
    
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_muestra_come_clpr;

  procedure pp_muestra_come_empl(p_empl_empr_codi in number,
                                 p_tiem_codi      in number,
                                 p_empl_codi_alte in varchar2,
                                 p_empl_desc      out varchar2,
                                 p_empl_codi      out number) is
  begin
    select e.empl_desc, e.empl_codi
      into p_empl_desc, p_empl_codi
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = p_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and ltrim(rtrim(upper(e.empl_codi_alte))) =
           ltrim(rtrim(upper(p_empl_codi_alte)));
  
  exception
    when no_data_found then
      p_empl_desc := null;
      p_empl_codi := null;
      raise_application_error(-20001,
                              'Empleado inexistente o no pertenece al tipo solicitado!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_empl;

  procedure pp_ejecutar_consulta(p_empr_codi      in number,
                                 p_tive_codi      in number,
                                 p_vehi_esta      in varchar2,
                                 p_docu_esta      in varchar2,
                                 p_orden          in varchar2,
                                 p_fech_desd      in date,
                                 p_fech_hast      in date,
                                 p_clpr_codi      in number,
                                 p_empl_codi      in number,
                                 p_empl_codi_recl in number,
                                 p_empl_codi_cobr in number) is
  begin
  
    --pp_recrea_tabla;
    --raise_application_error(-20001,'aca--');
  
    delete from t_vehi_docu_requ_a d
     where d.session_id = v('APP_SESSION')
       and d.usuario = fa_user;
    pp_proc_docu_vehi_a(p_empr_codi,
                        p_tive_codi,
                        p_vehi_esta,
                        p_docu_esta,
                        p_orden,
                        p_fech_desd,
                        p_fech_hast,
                        p_clpr_codi,
                        p_empl_codi,
                        p_empl_codi_recl,
                        p_empl_codi_cobr,
                        fa_user,
                        v('APP_SESSION'));
  
  end pp_ejecutar_consulta;

  /* procedure pp_recrea_tabla is
      v_user   varchar2(20) := fa_user;
      v_count  number;
      v_drop   varchar2(2000);
      v_create varchar2(2000);
    
    begin
      select count(*)
        into v_count
        from user_tables
       where table_name = upper('t_vehi_docu_requ');
     
      if v_count = 1 then
        v_drop := 'drop table ' || v_user || '.t_vehi_docu_requ';
        --pp_ejecuta_ddl(v_drop);
      end if;
   -- raise_application_error(-20001,'aaa '              ||v_user        ||v_count);
      v_create := 'create  table ' || v_user || '.t_vehi_docu_requ(
    item           number(10),
    indi_colo      varchar2(2),
    vehi_codi      number(20),
    vehi_iden      varchar2(60),
    tive_desc      varchar2(100),
    mave_desc      varchar2(100),
    vehi_mode      varchar2(60),
    vehi_anho      varchar2(10),
    vehi_colo      varchar2(60),
    vehi_nume_chas varchar2(60),
    vehi_nume_pate varchar2(20),
    vehi_esta      varchar2(1),
    clpr_desc      varchar2(120),
    ulti_nota      varchar2(2000),
    requ_codi_1    number(10),
    requ_desc_1    varchar2(100),
    dove_codi_1    number(20),
    dove_esta_1    varchar2(2),
    requ_codi_2    number(10),
    requ_desc_2    varchar2(100),
    dove_codi_2    number(20),
    dove_esta_2    varchar2(2),
    requ_codi_3    number(10),
    requ_desc_3    varchar2(100),
    dove_codi_3    number(20),
    dove_esta_3    varchar2(2),
    requ_codi_4    number(10),
    requ_desc_4    varchar2(100),
    dove_codi_4    number(20),
    dove_esta_4    varchar2(2),
    requ_codi_5    number(10),
    requ_desc_5    varchar2(100),
    dove_codi_5    number(20),
    dove_esta_5    varchar2(2),
    requ_codi_6    number(10),
    requ_desc_6    varchar2(100),
    dove_codi_6    number(20),
    dove_esta_6    varchar2(2),
    requ_codi_7    number(10),
    requ_desc_7    varchar2(100),
    dove_codi_7    number(20),
    dove_esta_7    varchar2(2),
    requ_codi_8    number(10),
    requ_desc_8    varchar2(100),
    dove_codi_8    number(20),
    dove_esta_8    varchar2(2),
    requ_codi_9    number(10),
    requ_desc_9    varchar2(100),
    dove_codi_9    number(20),
    dove_esta_9    varchar2(2),
    session        number
    )';
   
      --pp_ejecuta_ddl(v_create);
    
      if upper(v_user) <> upper('skn') then
        pp_ejecuta_ddl('grant insert , update, delete on ' || v_user ||
                       '.t_vehi_docu_requ to SKN');
      end if;
    
    end pp_recrea_tabla;
  */
  /* PROCEDURE pp_ejecuta_ddl(V_DDL IN CHAR) IS
    --OJO: dejar V_DDL como CHAR porque estaba como varchar2 y al recibir
    --     un string > 1000 letras da error en tiempo de ejecucion
    V_CURSOR    INTEGER;
    V_RESULTADO INTEGER;
  
  BEGIN
    V_CURSOR := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(V_CURSOR, V_DDL, 2); -- la constante (2) significa PL/SQL V.7
    V_RESULTADO := DBMS_SQL.EXECUTE(V_CURSOR);
    DBMS_SQL.CLOSE_CURSOR(V_CURSOR);
  
  
  END pp_ejecuta_ddl;
  */

  procedure pp_actualizar_registro(p_img       in varchar2,
                                   p_clave_img in number,
                                   p_dove_codi in number,
                                   p_vehi_cod  in number,
                                   p_requ_codi in number,
                                   p_estado    in varchar2,
                                   p_nro_item  in number,
                                   P_REQ_CODI_1 in number,
                                   P_REQU_DESC in varchar2) is
    v_archivo    blob;
    v_mime_type  varchar2(2000);
    v_filename   varchar2(2000);
    v_file_id    number;
    v_dove_codi  number;
    v_ind_exi    number;
    v_anexo_deta number;
  begin
  
    begin
      SELECT blob_content, mime_type, filename
        INTO v_archivo, v_mime_type, v_filename
        FROM apex_application_temp_files A
       WHERE A.NAME = p_img
         AND ROWNUM = 1;
    exception
      when others then
        null;
    end;
  
    -------archivo
    if p_clave_img is not null then
      update files_archivos
         set file_updated_by   = fa_user,
             file_updated_on   = sysdate,
             file_last_updated = sysdate,
             file_blob_content = nvl(v_archivo, file_blob_content),
             FILE_NAME         = v_filename,
             FILE_MIME_TYPE    = v_mime_type
       where file_id = p_clave_img;
    
    else
    
      if v_archivo is null then
        raise_application_error(-20001, 'Selecciona la Imagen a Guardar!');
      end if;
    
      begin
        select files_archivos_seq.nextval d into v_file_id from dual d;
      exception
        when no_data_found then
          v_file_id := null;
      end;
    
      insert into files_archivos
        (file_id,
         file_created_by,
         file_created_on,
         file_blob_content,
         FILE_NAME,
         FILE_MIME_TYPE)
      values
        (v_file_id, fa_user, sysdate, v_archivo, v_filename, v_mime_type);
    
    end if;
  
    --  RAISE_APPLICATION_ERROR(-20001,'vehi- '||p_vehi_cod||' -doc_re '||p_requ_codi||' -codi '||p_dove_codi); 
  
   if P_REQU_DESC not like '%Orden de Trabajo%' then
    update come_docu_requ_vehi
       set dove_esta      = p_estado,
           dove_user_modi = fa_user,
           dove_fech_modi = sysdate,
           dove_img       = nvl(p_clave_img, v_file_id)
     where dove_codi = nvl(p_dove_codi, dove_codi)
       and dove_vehi_codi = p_vehi_cod
       and dove_requ_codi = p_requ_codi;
       ---and dove_item=nvl(p_nro_item,dove_item);
       else
       update come_docu_requ_vehi
       set dove_esta      = p_estado,
           dove_user_modi = fa_user,
           dove_fech_modi = sysdate,
           dove_img       = nvl(p_clave_img, v_file_id)
     where dove_codi = nvl(p_dove_codi, dove_codi)
       and dove_vehi_codi = p_vehi_cod
       and dove_requ_codi = p_requ_codi
       and dove_item=nvl(p_nro_item,dove_item);
       
       end if;
       
       
 
       
  
    if sql%rowcount = 0 then
      begin
        select nvl(max(d.dove_codi), 0) + 1
          into v_dove_codi
          from come_docu_requ_vehi d;
      exception
        when no_data_found then
          v_dove_codi := 1;
      end;
    
    
    if P_REQU_DESC like '%Orden de Trabajo%' then
      begin
      
        select count(*), max(dove_anex_deta)
          into v_ind_exi, v_anexo_deta
          from come_docu_requ_vehi d
         where dove_requ_codi = P_REQ_CODI_1--v('P89_REQ_CODI_1')
           and dove_vehi_codi = p_vehi_cod
           and dove_item= p_nro_item;
      exception
        when no_data_found then
          null;
      end;
      else 
        begin
          select count(*), max(dove_anex_deta)
          into v_ind_exi, v_anexo_deta
          from come_docu_requ_vehi d
         where dove_requ_codi = P_REQ_CODI_1--v('P89_REQ_CODI_1')
           and dove_vehi_codi = p_vehi_cod;
      exception
        when no_data_found then
          null;
      end;
      end if;
      
    ---  raise_application_error(-20001, v('P89_REQ_CODI_1'));
      
    
      if v_ind_exi = 0 then
        insert into come_docu_requ_vehi
          (dove_codi,
           dove_vehi_codi,
           dove_requ_codi,
           dove_esta,
           dove_user_regi,
           dove_fech_regi,
           dove_img,
           dove_anex_deta,
           DOVE_ITEM)
        values
          (v_dove_codi,
           p_vehi_cod,
           P_REQ_CODI_1,
           p_estado,
           fa_user,
           sysdate,
           nvl(p_clave_img, v_file_id),
           v_anexo_deta,
           p_nro_item---nro de orden de trabajo....
           );
      end if;
    end if;
  
  end pp_actualizar_registro;

  procedure pp_registrar_nota(p_nove_desc_nuev varchar2,
                              p_vehi_codi      in number) is
    v_nove_codi number(20);
  
  begin
  
    if p_nove_desc_nuev is null then
      raise_application_error(-20001,
                              'No se puede registrar una nota en blanco');
    end if;
  
    begin
      select nvl(max(n.nove_codi), 0) + 1
        into v_nove_codi
        from come_nota_vehi n;
    exception
      when no_data_found then
        v_nove_codi := 1;
    end;
  
    insert into come_nota_vehi
      (nove_codi,
       nove_vehi_codi,
       nove_desc,
       nove_user_regi,
       nove_fech_regi)
    values
      (v_nove_codi, p_vehi_codi, p_nove_desc_nuev, fa_user, sysdate);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_registrar_nota;

  procedure pp_proc_docu_vehi_a(p_empr_codi      in number,
                                p_tive_codi      in number,
                                p_vehi_esta      in varchar2,
                                p_docu_esta      in varchar2,
                                p_order          in varchar2,
                                p_fech_desd      in date,
                                p_fech_hast      in date,
                                p_clpr_codi      in number,
                                p_empl_codi      in number,
                                p_empl_codi_recl in number,
                                p_empl_codi_cobr in number,
                                p_user           in varchar2,
                                P_session        in number default null) is
  
    type rt_regi_vehi is record(
      item             number(10),
      indi_colo        varchar2(2),
      vehi_codi        number(20),
      vehi_iden        varchar2(60),
      tive_desc        varchar2(100),
      mave_desc        varchar2(100),
      vehi_mode        varchar2(60),
      vehi_anho        varchar2(10),
      vehi_colo        varchar2(60),
      vehi_nume_chas   varchar2(60),
      vehi_nume_pate   varchar2(20),
      vehi_esta        varchar2(1),
      clpr_desc        varchar2(120),
      ulti_nota        varchar2(2000),
      indi_most        varchar2(20),
      session_id       number,
      usuario          varchar2(30),
      vehi_tive_codi   number,
      ot_fecha_emision date);
    type tt_regi_vehi is table of rt_regi_vehi index by binary_integer;
    ta_regi_vehi tt_regi_vehi;
    ta_regi_defi tt_regi_vehi;
  
    type CurTyp is ref cursor;
    c_docu CurTyp;
  
    sql_stmt    varchar2(10000);
    v_where     varchar2(4000) := ' ';
    v_order     varchar2(500) := ' ';
    v_where_ot  varchar2(2000);
    v_sql_final varchar2(10000);
  
    v_idx number := 0;
  
    --######################################################################
    --# funcion interna para insertar la relacion del documento y vehiculo #
    --######################################################################
    function fi_insert_docu_vehi(pin_vehi_codi in number,
                                 pin_requ_codi in number) return number is
      v_dove_codi      number(20);
      v_dove_vehi_codi number(20);
      v_dove_requ_codi number(10);
      v_dove_esta      varchar2(2);
      v_dove_user_regi varchar2(20);
      v_dove_fech_regi date;
      v_dove_user_modi varchar2(20);
      v_dove_fech_modi date;
    
    begin
      begin
        select nvl(max(d.dove_codi), 0) + 1
          into v_dove_codi
          from come_docu_requ_vehi d;
      exception
        when no_data_found then
          v_dove_codi := 1;
      end;
    
      v_dove_vehi_codi := pin_vehi_codi;
      v_dove_requ_codi := pin_requ_codi;
      v_dove_esta      := 'NO';
      v_dove_user_regi := p_user;
      v_dove_fech_regi := sysdate;
      v_dove_user_modi := null;
      v_dove_fech_modi := null;
    
      insert into come_docu_requ_vehi
        (dove_codi,
         dove_vehi_codi,
         dove_requ_codi,
         dove_esta,
         dove_user_regi,
         dove_fech_regi,
         dove_user_modi,
         dove_fech_modi)
      values
        (v_dove_codi,
         v_dove_vehi_codi,
         v_dove_requ_codi,
         v_dove_esta,
         v_dove_user_regi,
         v_dove_fech_regi,
         v_dove_user_modi,
         v_dove_fech_modi);
    
      return v_dove_codi;
    
    exception
      when others then
        return null;
    end fi_insert_docu_vehi;
  
  begin
    --where
    if p_empr_codi is not null then
      --  v_where := v_where || ' and r.requ_empr_codi = ' || p_empr_codi;
      NULL;
    end if;
    if p_tive_codi is not null then
      v_where := v_where || ' and v.vehi_tive_codi  = ' || p_tive_codi;
    end if;
    if nvl(p_vehi_esta, 'T') != 'T' then
      v_where := v_where || ' and v.vehi_esta = ' || chr(39) || p_vehi_esta ||
                 chr(39);
    end if;
    if p_clpr_codi is not null then
      v_where := v_where || ' and c.clpr_codi = ' || p_clpr_codi;
    end if;
    if p_empl_codi is not null then
      v_where := v_where || ' and c.clpr_empl_codi = ' || p_empl_codi;
    end if;
    if p_empl_codi_recl is not null then
      v_where := v_where || ' and c.clpr_empl_codi_recl = ' ||
                 p_empl_codi_recl;
    end if;
    if p_empl_codi_cobr is not null then
      v_where := v_where || ' and c.clpr_empl_codi_cobr = ' ||
                 p_empl_codi_cobr;
    end if;
    if p_fech_desd is not null then
      if v_where_ot is null then
        v_where_ot := ' select 1' || ' from come_orde_trab o' ||
                      ' where o.ortr_vehi_codi = v.vehi_codi' ||
                      ' and o.ortr_fech_emis >= ' || chr(39) ||
                      to_char(p_fech_desd, 'dd-mm-yyyy') || chr(39);
      else
        v_where_ot := v_where_ot || ' and o.ortr_fech_emis >= ' || chr(39) ||
                      to_char(p_fech_desd, 'dd-mm-yyyy') || chr(39);
      end if;
    end if;
    if p_fech_hast is not null then
      if v_where_ot is null then
        v_where_ot := ' select 1' || ' from come_orde_trab o' ||
                      ' where o.ortr_vehi_codi = v.vehi_codi' ||
                      ' and o.ortr_fech_emis <= ' || chr(39) ||
                      to_char(p_fech_hast, 'dd-mm-yyyy') || chr(39);
      else
        v_where_ot := v_where_ot || ' and o.ortr_fech_emis <= ' || chr(39) ||
                      to_char(p_fech_hast, 'dd-mm-yyyy') || chr(39);
      end if;
    end if;
    if v_where_ot is not null then
      v_where := v_where || ' and exists (' || v_where_ot || ')';
    end if;
  
    --order by
    if p_order is not null then
      v_order := ' order by ' || p_order || ', v.vehi_iden, v.vehi_codi';
    else
      v_order := ' order by v.vehi_iden, v.vehi_codi';
    end if;
  
    --consulta final
    sql_stmt := 'select 
               null item,
          I020366.fl_ind_estado(v.vehi_codi) indi_colo,
         vehi_codi,
         v.vehi_iden,
         t.tive_desc,
         m.mave_desc,
         v.vehi_mode,
         v.vehi_anho,
         v.vehi_colo,
         v.vehi_nume_chas,
         v.vehi_nume_pate,
         v.vehi_esta,
         c.clpr_desc,
         null ulti_nota,
         null indi_most,
         null jg,
         null ud,
         v.vehi_tive_codi,
        (select max(ORTR_FECH_EMIS) fecha from come_orde_trab
          where  ortr_vehi_codi = v.vehi_codi) fecha_emision
  from come_vehi           v,
         come_tipo_vehi      t,
         come_marc_vehi      m,
         come_clie_prov      c
   where v.vehi_tive_codi = t.tive_codi
     and v.vehi_mave_codi = m.mave_codi
     and v.vehi_clpr_codi = c.clpr_codi
     and nvl(v.vehi_esta_vehi, ''A'') = ''A''' || v_where ||
                v_order;
  
    insert into come_concat (campo1, otro) values (sql_stmt, 'marisa');
  
    open c_docu for sql_stmt;
    fetch c_docu bulk collect
      into ta_regi_vehi;
    close c_docu;
  
    v_idx := 0;
    for x in 1 .. ta_regi_vehi.count loop
      v_idx := v_idx + 1;
      ta_regi_defi(v_idx).item := v_idx;
      ta_regi_defi(v_idx).indi_colo := ta_regi_vehi(x).indi_colo;
      ta_regi_defi(v_idx).vehi_codi := ta_regi_vehi(x).vehi_codi;
      ta_regi_defi(v_idx).vehi_iden := ta_regi_vehi(x).vehi_iden;
      ta_regi_defi(v_idx).tive_desc := ta_regi_vehi(x).tive_desc;
      ta_regi_defi(v_idx).mave_desc := ta_regi_vehi(x).mave_desc;
      ta_regi_defi(v_idx).vehi_mode := ta_regi_vehi(x).vehi_mode;
      ta_regi_defi(v_idx).vehi_anho := ta_regi_vehi(x).vehi_anho;
      ta_regi_defi(v_idx).vehi_colo := ta_regi_vehi(x).vehi_colo;
      ta_regi_defi(v_idx).vehi_nume_chas := ta_regi_vehi(x).vehi_nume_chas;
      ta_regi_defi(v_idx).vehi_nume_pate := ta_regi_vehi(x).vehi_nume_pate;
      ta_regi_defi(v_idx).vehi_esta := ta_regi_vehi(x).vehi_esta;
      ta_regi_defi(v_idx).clpr_desc := ta_regi_vehi(x).clpr_desc;
      ta_regi_defi(v_idx).session_id := P_session;
      ta_regi_defi(v_idx).usuario := p_user;
      ta_regi_defi(v_idx).vehi_tive_codi := ta_regi_vehi(x).vehi_tive_codi;
      ta_regi_defi(v_idx).ot_fecha_emision := ta_regi_vehi(x).ot_fecha_emision;
    
      if p_docu_esta = 'C' and ta_regi_vehi(x).indi_colo = 'C' then
        ta_regi_defi(v_idx).indi_most := 'C';
      elsif p_docu_esta = 'P' and ta_regi_vehi(x).indi_colo = 'P' then
        ta_regi_defi(v_idx).indi_most := 'P';
      elsif p_docu_esta = 'R' and ta_regi_vehi(x).indi_colo = 'R' then
        ta_regi_defi(v_idx).indi_most := 'R';
      elsif p_docu_esta = 'T' THEN
        ta_regi_defi(v_idx).indi_most := 'T';
      END IF;
    
      begin
        select n.nove_desc
          into ta_regi_defi(v_idx).ulti_nota
          from come_nota_vehi n
         where n.nove_codi =
               (select max(nv.nove_codi)
                  from come_nota_vehi nv
                 where nv.nove_vehi_codi = ta_regi_defi(v_idx).vehi_codi);
      exception
        when no_data_found then
          ta_regi_defi(v_idx).ulti_nota := null;
      end;
    
    end loop;
  
    begin
      for i in 1 .. ta_regi_defi.count loop
        v_sql_final := 'insert into  t_vehi_docu_requ_a (
      item,
      indi_colo,
      vehi_codi,
      vehi_iden,
      tive_desc,
      mave_desc,
      vehi_mode,
      vehi_anho,
      vehi_colo,
      vehi_nume_chas,
      vehi_nume_pate,
      vehi_esta,
      clpr_desc,
      ulti_nota,
      session_id,
      usuario,
      vehi_tive_codi,
      indi_most,
      OT_FECHA_EMISION
      ) values (
      :1,
      :2,
      :3,
      :4,
      :5,
      :6,
      :7,
      :8,
      :9,
      :10,
      :11,
      :12,
      :13,
      :14,
      :15,
      :16,
      :17,
      :18,
      :19
      )';
        execute immediate v_sql_final
          using ta_regi_defi(i).item, 
           ta_regi_defi(i).indi_colo, 
           ta_regi_defi(i).vehi_codi, 
           ta_regi_defi(i).vehi_iden, 
           ta_regi_defi(i).tive_desc, 
           ta_regi_defi(i).mave_desc, 
           ta_regi_defi(i).vehi_mode, 
           ta_regi_defi(i).vehi_anho, 
           ta_regi_defi(i).vehi_colo, 
           ta_regi_defi(i).vehi_nume_chas, 
           ta_regi_defi(i).vehi_nume_pate, 
           ta_regi_defi(i).vehi_esta, 
           ta_regi_defi(i).clpr_desc, 
           ta_regi_defi(i).ulti_nota, 
           ta_regi_defi(i).session_id, 
           ta_regi_defi(i).usuario, 
           ta_regi_defi(i).vehi_tive_codi, 
           ta_regi_defi(i).indi_most,
           ta_regi_defi(i).ot_fecha_emision;
      
      end loop;
    end;
  
    commit;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;
  function pp_check_estado(p_tipo_doc in number) return varchar2 is
  
    cursor preg is
      select TP.REQU_CODI,
             TP.REQU_DESC,
             TP.REQU_TIVE_CODI,
             TV.TIVE_DESC,
             tp.REQU_ORDEN,
             dove_esta estado,
             dove_vehi_codi,
             v.dove_requ_codi,
             v.dove_codi,
             v.dove_anex_deta,
             
             case
               when dove_esta = 'SI' then
                DECODE(NVL(dove_esta, 'X'), 'SI', ' checked ', NULL)
             end EST_SI,
             case
               when dove_esta = 'NO' then
                DECODE(NVL(V.dove_esta, 'X'), 'NO', ' checked ', NULL)
             END EST_NO,
             case
               when dove_esta = 'NA' then
                DECODE(NVL(V.dove_esta, 'X'), 'NA', ' checked ', NULL)
             END EST_NA
        from COME_DOCU_REQU_TIPO tp,
             COME_TIPO_VEHI      TV,
             come_docu_requ_vehi v,
             files_archivos      ar
       where tp.requ_codi = DOVE_REQU_CODI
         AND TP.REQU_TIVE_CODI = TV.TIVE_CODI
         and dove_img = ar.file_id
         and dove_vehi_codi = v('P89_VEHI_COD')
         and v.dove_requ_codi = p_tipo_doc
       order by tp.REQU_ORDEN;
  
    V_ADJUNTO VARCHAR(32000);
  begin
    v_adjunto := v_adjunto || '<PRE style="font-size:15px;">';
  
    for r in preg loop
      -----GENERA EL CUERPO DEL JAVASCRITP PARA PRECENTAR EN LA PANTALLA DE APEX..
      V_ADJUNTO := V_ADJUNTO || 'Si: <input type="radio" ' || r.est_si ||
                   ' onclick=javascript:$s("P89_ID",' || p_tipo_doc ||
                   ');javascript:$s("P89_DOVE_CODI",' || r.dove_codi ||
                   ');javascript:$s("P89_TIPO","SI"); id="' || p_tipo_doc ||
                   'age1" name="' || p_tipo_doc || '">' ||
                   ' No: <input type="radio" ' || r.est_no ||
                   ' onclick=javascript:$s("P89_ID",' || p_tipo_doc ||
                   ');javascript:$s("P89_DOVE_CODI",' || r.dove_codi ||
                   ');javascript:$s("P89_TIPO","NO"); id="' || p_tipo_doc ||
                   'age1" name="' || p_tipo_doc || '">' ||
                   ' NO Aplica: <input type="radio" ' || r.est_na ||
                   ' onclick=javascript:$s("P89_ID",' || p_tipo_doc ||
                   ');javascript:$s("P89_DOVE_CODI",' || r.dove_codi ||
                   ');javascript:$s("P89_TIPO","NA"); id="' || p_tipo_doc ||
                   'age2"  name="' || p_tipo_doc || '' || '"></br>';
    
    END LOOP;
  
    RETURN V_ADJUNTO || '</PRE>';
  
  end pp_check_estado;
  
  
  function pp_imag_docu (i_file_id in number) return varchar2 is
    
    v_link varchar2(15000);
    
   begin
       
    --v_link := '<pre> <img src= href="http://168.138.147.91:8080/ords/walrusws/archivo/file/'||i_file_id||'" id="imag_'||i_file_id||'" onclick="imgClickCargar("imag_'||i_file_id||'")"></> </pre>';
     v_link := '<img src=http://140.238.186.240:8080/ords/walrusws/imagenes_vendedor/vendedor/'||i_file_id||'></>';
 
    return v_link;
   
   end pp_imag_docu;

  procedure pp_actualizar_estado(p_estado    in varchar,
                                 p_vehi_cod  in number,
                                 p_requ_codi in number,
                                 p_dove_codi in number) is
  begin
  
    update come_docu_requ_vehi
       set dove_esta      = p_estado,
           dove_user_modi = fa_user,
           dove_fech_modi = sysdate
     where dove_codi = p_dove_codi
       and dove_vehi_codi = p_vehi_cod
       and dove_requ_codi = p_requ_codi;
  
  end pp_actualizar_estado;

  function fl_ind_estado(p_vehi_codi in number) return varchar2 is
  
    cursor b is
      select dove_esta, requ_desc, dove_img
        from come_docu_requ_vehi d, COME_DOCU_REQU_TIPO g
       where d.dove_requ_codi = g.requ_codi
         and d.dove_vehi_codi = p_vehi_codi;
    v_ind_no       varchar2(2);
    v_ind_si       varchar2(2);
    v_ind_anexo    varchar2(2);
    v_ind_orden    varchar2(2);
    v_ind_servicio varchar2(2);
    v_ind_faltante varchar2(2);
  
  begin
    for i in b loop
      if i.dove_esta = 'NO' and i.dove_img is not null then
        v_ind_no := 'NO';
      elsif i.dove_esta = 'SI' and i.dove_img is not null then
        v_ind_si := 'SI';
      end if;
    
      if i.requ_desc = 'Orden de Trabajo' and i.dove_img is not null then
        v_ind_orden := 'S';
      elsif i.requ_desc = 'Anexo' and i.dove_img is not null then
        v_ind_anexo := 'S';
      elsif i.requ_desc = 'Solicitud de Servicio' and
            i.dove_img is not null then
        v_ind_servicio := 'S';
      end if;
    
    end loop;
  
    if v_ind_orden = 'S' and v_ind_anexo = 'S' and v_ind_servicio = 'S' then
      v_ind_faltante := 'F';
    end if;
  
    if v_ind_no = 'NO' and v_ind_faltante = 'F' then
      return 'R';
    elsif v_ind_si = 'SI' and v_ind_faltante = 'F' and v_ind_no is null then
      return 'C';
    elsif (v_ind_no is null and v_ind_si is null or v_ind_faltante is null) then
      return 'P';
    end if;
  
  end fl_ind_estado;
  
 procedure pp_validar_scan_ot(p_ot in number) 
    is
   v_ind_exist number;
   v_ortr_nume number;
    
   begin
     begin
     select  d.ortr_nume into v_ortr_nume
      from come_orde_trab d
      where  d.ortr_codi = p_ot
      and d.ortr_serv_tipo='I';
      exception when no_data_found then
        v_ortr_nume:=null;
       end;   
          
      select count(*) ind_exist
          into v_ind_exist
          from come_docu_requ_vehi d,come_docu_requ_tipo g
         where dove_requ_codi = g.requ_codi
           and g.requ_desc = 'Orden de Trabajo'
           and dove_item= v_ortr_nume ;
           
           
   if v_ind_exist=0 and v_ortr_nume is not null then
       raise_application_error(-20001,'Falta agregar el escaneado de la Orden de Trabajo...'); 
     end if;
end pp_validar_scan_ot;
  
  
  procedure pp_eliminar_imagen(p_vehi_codi in number,
                               p_dove_codi in number,
                               p_requ_codi in number,
                               p_file_id   in number) is
  begin
  
    update come_docu_requ_vehi
       set dove_img = null
     where dove_codi = p_dove_codi
       and dove_vehi_codi = p_vehi_codi
       and dove_requ_codi = p_requ_codi;
  
    -----elimina la imagen del sistema  
    delete from files_archivos g where g.file_id = p_file_id;
  
  end pp_eliminar_imagen;
  
  ---------------------------------------------------------------------------
  function fp_get_tipo_vehi(i_filtro in varchar2) return varchar2 is
    v_return varchar2(1000) := null;
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select tive_codi
      into v_return
      from come_tipo_vehi v
     where v.tive_codi_alte = i_filtro
       and v.tive_empr_codi = fa_empresa;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select tive_codi
        into v_return
        from come_tipo_vehi v
       where v.tive_empr_codi = fa_empresa
         and upper(v.tive_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
    return null;
  end fp_get_tipo_vehi;

  ---------------------------------------------------------------------------
  function fp_get_clie_prov(i_filtro in varchar2) return varchar2 is
    v_return varchar2(1000) := null;
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select c.clpr_codi
        into v_return
        from come_clie_prov c
       where c.clpr_indi_clie_prov = 'C'
         and c.clpr_empr_codi = fa_empresa
         and c.clpr_codi_alte = i_filtro;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select c.clpr_codi
        into v_return
        from come_clie_prov c
       where c.clpr_indi_clie_prov = 'C'
         and c.clpr_empr_codi = fa_empresa
         and upper(c.clpr_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
    return null;
  end fp_get_clie_prov;
  
  ---------------------------------------------------------------------------
  function fp_get_empl_agen(i_filtro in varchar2) return varchar2 is
    v_return varchar2(1000) := null;
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = fa_busc_para('p_codi_tipo_empl_vend')
         and e.empl_esta = 'A'
         and e.empl_empr_codi = fa_empresa
         and e.empl_codi_alte = i_filtro;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = fa_busc_para('p_codi_tipo_empl_vend')
         and e.empl_esta = 'A'
         and e.empl_empr_codi = fa_empresa
         and upper(e.empl_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
    return null;
  end fp_get_empl_agen;

  ---------------------------------------------------------------------------
  function fp_get_empl_recl(i_filtro in varchar2) return varchar2 is
    v_return varchar2(1000) := null;
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = fa_busc_para('p_codi_tipo_empl_recl')
         and e.empl_esta = 'A'
         and e.empl_empr_codi = fa_empresa
         and e.empl_codi_alte = i_filtro;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = fa_busc_para('p_codi_tipo_empl_recl')
         and e.empl_esta = 'A'
         and e.empl_empr_codi = fa_empresa
         and upper(e.empl_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
    return null;
  end fp_get_empl_recl;

  ---------------------------------------------------------------------------
  function fp_get_empl_empl_cobr(i_filtro in varchar2) return varchar2 is
    v_return varchar2(1000) := null;
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi =fa_busc_para('p_codi_tipo_empl_cobr') 
         and e.empl_empr_codi = fa_empresa
         and e.empl_codi_alte = i_filtro;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi =fa_busc_para('p_codi_tipo_empl_cobr') 
         and e.empl_empr_codi = fa_empresa
         and upper(e.empl_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
    return null;
  end fp_get_empl_empl_cobr;


end I020366;
