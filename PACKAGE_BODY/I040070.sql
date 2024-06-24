
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I040070" is

  type r_parameter is record(
    p_report              varchar2(20),
    p_titulo              varchar2(50) := ' - Balance General',
    p_app_session         number,
    p_indi_most_cero      varchar2(2),
    p_ejer_codi           come_ejer_fisc.ejer_codi%type,
    p_ejer_desc           come_ejer_fisc.ejer_desc%type,
    p_mone_codi           come_mone.mone_codi%type,
    p_mone_desc           come_mone.mone_desc%type,
    p_ceco_codi           come_cent_cost.ceco_codi%type,
    p_ceco_desc           come_cent_cost.ceco_desc%type,
    p_codi_ejer_fisc_actu number := to_number(general_skn.fl_busca_parametro('p_codi_ejer_fisc_actu')),
    p_codi_mone_mmnn      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_mone_mmee      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    p_form_libro_mayor    varchar2(20) := general_skn.fl_busca_parametro('P_FORM_LIBRO_MAYOR'));

  parameter r_parameter;

  procedure pp_llama_reporte is
    v_parametros   clob;
    v_contenedores clob;
  begin
    v_contenedores := 'p_app_session:p_user:p_titulo';
  
    v_parametros := parameter.p_app_session || ':' || chr(39) || gen_user ||
                    chr(39) || ':' || parameter.p_report ||
                    parameter.p_titulo;
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, gen_user, parameter.p_report, 'pdf', v_contenedores);
  
    commit;
  end pp_llama_reporte;

  procedure pa_bala_gral_bc(p_indi           out number,
                            p_tipo           in char,
                            p_fech_inic      in date,
                            p_fech_fini      in date,
                            p_ceco_codi      in number,
                            p_indi_excl_cier in varchar2) is
  
    cursor c_plan is
      select a.cuco_codi,
             a.cuco_nume,
             a.cuco_desc,
             a.cuco_nume_orig,
             a.cuco_nive,
             nvl(a.cuco_indi_impu, 'N') cuco_indi_impu,
             a.cuco_tica_codi,
             a.cuco_cuco_codi,
             a.cuco_tipo_cuen,
             null tipo_sald,
             null impo_mmnn,
             null impo_mmee
        from v_plan_cuen a
       where (a.cuco_tipo_cuen in ('A', 'P') and p_tipo = 'AP')
          or (a.cuco_tipo_cuen in ('I', 'E') and p_tipo = 'IE')
       order by cuco_nume_orig;
  
    type rt_plan is record(
      cuco_codi      number(20),
      cuco_nume      varchar2(4000),
      cuco_desc      varchar2(4000),
      cuco_nume_orig number(20),
      cuco_nive      number(10),
      cuco_indi_impu varchar2(1),
      cuco_tica_codi number(4),
      cuco_cuco_codi number(10),
      cuco_tipo_cuen varchar2(1),
      tipo_sald      varchar2(2),
      impo_mmnn      number,
      impo_mmee      number);
  
    type tt_plan is table of rt_plan index by binary_integer;
    ta_plan tt_plan;
  
    v_nume_item         number := 0;
    v_impo              number := 0;
    v_impo_mmee         number := 0;
    v_tota_impo_mmnn_ai number := 0;
    v_tota_impo_mmnn_pe number := 0;
    v_impo_resu_mmnn    number := 0;
  
    ---para determinar el total de los asientos por cuenta...
    cursor c_asi(p_fech_inic in date,
                 p_fech_fini in date,
                 p_asie_cier in number) is
      select c.cuco_nume,
             d.deta_cuco_codi,
             c.cuco_indi_impu,
             c.cuco_tipo_cuen,
             sum(decode(c.cuco_tipo_cuen,
                        'A',
                        decode(d.deta_indi_dbcr,
                               'H',
                               d.deta_impo_mmnn * (-1),
                               d.deta_impo_mmnn),
                        'P',
                        decode(d.deta_indi_dbcr,
                               'D',
                               d.deta_impo_mmnn * (-1),
                               d.deta_impo_mmnn),
                        'I',
                        decode(d.deta_indi_dbcr,
                               'H',
                               d.deta_impo_mmnn * (-1),
                               d.deta_impo_mmnn),
                        'E',
                        decode(d.deta_indi_dbcr,
                               'D',
                               d.deta_impo_mmnn * (-1),
                               d.deta_impo_mmnn))) deta_impo_mmnn
        from come_asie a, come_asie_deta d, come_cuen_cont c
       where a.asie_codi = d.deta_asie_codi
         and d.deta_cuco_codi = c.cuco_codi
         and (p_ceco_codi is null or d.deta_ceco_codi = p_ceco_codi)
         and a.asie_fech_emis between p_fech_inic and p_fech_fini
         and ((c.cuco_tipo_cuen in ('A', 'P') and p_tipo = 'AP') or
             (c.cuco_tipo_cuen in ('I', 'E') and p_tipo = 'IE'))
         and ((nvl(p_indi_excl_cier, 'N') = 'S' and
             (p_asie_cier is null or
             (p_asie_cier is not null and a.asie_codi <> p_asie_cier))) or
             (nvl(p_indi_excl_cier, 'N') = 'N'))
       group by c.cuco_nume,
                d.deta_cuco_codi,
                c.cuco_indi_impu,
                c.cuco_tipo_cuen
       order by c.cuco_nume, d.deta_cuco_codi, c.cuco_indi_impu;
  
    type rt_asie is record(
      cuco_nume      number(20),
      deta_cuco_codi number(20),
      cuco_indi_impu varchar2(1),
      cuco_tipo_cuen varchar2(2),
      deta_impo_mmnn number(20, 4));
  
    type tt_asie is table of rt_asie index by binary_integer;
    ta_asie tt_asie;
  
    tabla_llaveada exception;
    pragma exception_init(tabla_llaveada, -54);
  
    v_cuco_nume      varchar2(100);
    v_cuco_codi      number;
    v_cuco_desc      varchar2(500);
    v_cuco_nive      number;
    v_cuco_nume_orig number;
    v_indi_entro     char(1) := 'N';
    v_tipo_sald      varchar2(2);
    v_tipo_sald_resu varchar2(2);
    v_cuco_tipo_cuen varchar2(1);
  
    v_sql_final                varchar2(10000);
    v_exit                     varchar2(1) := 'N';
    v_reg                      number := 0;
    v_user                     varchar2(20) := gen_user;
    v_cuco_resu_gana_perd      number;
    v_cuco_codi_resu_gana_perd number;
    v_asie_cier                number;
  
    type tt_plan_cuen is table of t_plan_cuen%rowtype index by binary_integer;
    ta_plan_cuen      tt_plan_cuen;
    ta_plan_cuen_resu tt_plan_cuen;
  
  begin
  
    pa_ejecuta_ddl('alter session set nls_date_format =' || '''' ||
                   'DD-MM-YYYY' || '''');
  
    --indicadores de salida
    --0 = Termino correctamente
    --1 = Esta blooquedao por otro usuario
    --2 = alguna cuenta no imputable tiene saldo..
  
    if p_tipo = 'AP' then
      v_cuco_resu_gana_perd := to_number(fa_busc_para('p_cuco_resu'));
    else
      v_cuco_resu_gana_perd := to_number(fa_busc_para('p_cuco_gana_perd'));
    end if;
  
    begin
      select cuco_codi
        into v_cuco_codi_resu_gana_perd
        from come_cuen_cont
       where cuco_nume = v_cuco_resu_gana_perd;
    
    exception
      when no_data_found then
        null;
    end;
  
   
    p_indi       := 0;
    v_indi_entro := 'N';
  
    begin
      select ejer_asie_cier
        into v_asie_cier
        from come_ejer_fisc
       where ejer_fech_inic = p_fech_inic
         and ejer_fech_fina >= p_fech_fini;
    
    exception
      when no_data_found then
        v_asie_cier := null;
    end;
  
   --pl_me(v_asie_cier);
    for v in c_asi(p_fech_inic, p_fech_fini, v_asie_cier) loop
      ta_asie(c_asi%rowcount).cuco_nume := v.cuco_nume;
      ta_asie(c_asi%rowcount).deta_cuco_codi := v.deta_cuco_codi;
      ta_asie(c_asi%rowcount).cuco_indi_impu := v.cuco_indi_impu;
      ta_asie(c_asi%rowcount).cuco_tipo_cuen := v.cuco_tipo_cuen;
      ta_asie(c_asi%rowcount).deta_impo_mmnn := v.deta_impo_mmnn;
    end loop;
   
    for x in 1 .. ta_asie.count loop
      if ta_asie(x).cuco_indi_impu = 'N' then
        v_indi_entro := 'S';
      end if;
    end loop;

    if v_indi_entro = 'S' then
      p_indi := 2;
    end if;

    if p_indi = 0 then

      open c_plan;
      fetch c_plan bulk collect
        into ta_plan;
      close c_plan;
    
      dbms_output.put_line(ta_plan.count);
    
      --asignar el importe a cada cuenta
      v_impo := 0;
    
      for i in 1 .. ta_asie.COUNT loop
        for x in 1 .. ta_plan.count loop
          if ta_plan(x).cuco_codi = ta_asie(i).deta_cuco_codi then
          
            if (nvl(ta_asie(i).deta_impo_mmnn, 0) >= 0 and ta_asie(i)
               .cuco_tipo_cuen in ('A', 'E')) or
               (nvl(ta_asie(i).deta_impo_mmnn, 0) < 0 and ta_plan(x)
               .cuco_tipo_cuen in ('P', 'I')) then
            
              ta_plan(x).tipo_sald := 'DB';
            else
              ta_plan(x).tipo_sald := 'CR';
            end if;
          
            ta_plan(x).impo_mmnn := abs(nvl(ta_asie(i).deta_impo_mmnn, 0));
          
            if ta_asie(i).cuco_tipo_cuen in ('A', 'I') then
              v_tota_impo_mmnn_ai := v_tota_impo_mmnn_ai +
                                     nvl(ta_asie(i).deta_impo_mmnn, 0);
            else
              v_tota_impo_mmnn_pe := v_tota_impo_mmnn_pe +
                                     nvl(ta_asie(i).deta_impo_mmnn, 0);
            end if;
          
            exit;
          end if;
        end loop;
      end loop;
    
      v_impo_resu_mmnn := v_tota_impo_mmnn_ai - v_tota_impo_mmnn_pe;
    
      if p_tipo = 'AP' then
        if v_impo_resu_mmnn > 0 then
          v_tipo_sald_resu := 'CR';
        else
          v_tipo_sald_resu := 'DB';
        end if;
      else
        if v_impo_resu_mmnn <= 0 then
          v_tipo_sald_resu := 'CR';
        else
          v_tipo_sald_resu := 'DB';
        end if;
      end if;
    
      v_nume_item := 0;
      for x in 1 .. ta_plan.count loop
        v_nume_item := v_nume_item + 1;
      
        if nvl(ta_plan(x).cuco_indi_impu, 'N') = 'S' then
          ta_plan_cuen(x).impo_mmnn := nvl(ta_plan(x).impo_mmnn, 0);
        else
          ta_plan_cuen(x).impo_mmnn := null;
        end if;
      
        ta_plan_cuen(x).cuco_codi := ta_plan(x).cuco_codi;
        ta_plan_cuen(x).cuco_nume := ta_plan(x).cuco_nume;
        ta_plan_cuen(x).nume_item := v_nume_item;
        ta_plan_cuen(x).cuco_desc := ta_plan(x).cuco_desc;
        ta_plan_cuen(x).cuco_nive := ta_plan(x).cuco_nive;
        ta_plan_cuen(x).cuco_indi_impu := ta_plan(x).cuco_indi_impu;
        ta_plan_cuen(x).indi_tota := 'N';
        ta_plan_cuen(x).cuco_cuco_codi := ta_plan(x).cuco_cuco_codi;
        ta_plan_cuen(x).cuco_nume_orig := ta_plan(x).cuco_nume_orig;
        ta_plan_cuen(x).impo_mmee := null;
        ta_plan_cuen(x).cuco_tipo_cuen := ta_plan(x).cuco_tipo_cuen;
        ta_plan_cuen(x).tipo_sald := ta_plan(x).tipo_sald;
      
        if ta_plan_cuen(x).cuco_codi = v_cuco_codi_resu_gana_perd then
          ta_plan_cuen(x).impo_mmnn := abs(v_impo_resu_mmnn);
          ta_plan_cuen(x).tipo_sald := v_tipo_sald_resu;
        end if;
      
      end loop;
    
      for i in 1 .. ta_plan_cuen.COUNT loop
        if ta_plan_cuen(i).cuco_indi_impu = 'N' and ta_plan_cuen(i).indi_tota = 'N' then
          v_cuco_desc      := (lpad(' ',
                                    4 * (ta_plan_cuen(i).cuco_nive - 1),
                                    ' ')) || 'Total' || '    ' ||
                              (ltrim(rtrim(ta_plan_cuen(i).cuco_desc)));
          v_cuco_nume      := ta_plan_cuen(i).cuco_nume;
          v_cuco_codi      := ta_plan_cuen(i).cuco_codi;
          v_cuco_nive      := ta_plan_cuen(i).cuco_nive;
          v_impo           := 0;
          v_impo_mmee      := 0;
          v_cuco_nume_orig := ta_plan_cuen(i).cuco_nume_orig;
          v_nume_item      := null;
          v_indi_entro     := 'N';
          v_cuco_tipo_cuen := ta_plan_cuen(i).cuco_tipo_cuen;
          v_exit           := 'N';
        
          for x in 1 .. ta_plan_cuen.COUNT loop
            if v_exit = 'N' then
              if ta_plan_cuen(x).indi_tota = 'N' and ta_plan_cuen(x).nume_item > ta_plan_cuen(i).nume_item then
                if ta_plan_cuen(x).cuco_nive <= ta_plan_cuen(i).cuco_nive then
                  v_indi_entro := 'S';
                  if v_impo >= 0 then
                    v_tipo_sald := 'DB';
                  else
                    v_tipo_sald := 'CR';
                  end if;
                
                  v_reg := v_reg + 1;
                  ta_plan_cuen_resu(v_reg).cuco_codi := v_cuco_codi;
                  ta_plan_cuen_resu(v_reg).cuco_nume := v_cuco_nume;
                  ta_plan_cuen_resu(v_reg).impo_mmnn := abs(v_impo);
                  ta_plan_cuen_resu(v_reg).impo_mmee := abs(v_impo_mmee);
                  ta_plan_cuen_resu(v_reg).tipo_sald := v_tipo_sald;
                  ta_plan_cuen_resu(v_reg).nume_item := v_nume_item;
                  ta_plan_cuen_resu(v_reg).cuco_desc := v_cuco_desc;
                  ta_plan_cuen_resu(v_reg).cuco_nive := v_cuco_nive;
                  ta_plan_cuen_resu(v_reg).cuco_indi_impu := 'N';
                  ta_plan_cuen_resu(v_reg).indi_tota := 'S';
                  ta_plan_cuen_resu(v_reg).cuco_nume_orig := v_cuco_nume_orig;
                  ta_plan_cuen_resu(v_reg).cuco_tipo_cuen := v_cuco_tipo_cuen;
                  v_exit := 'S';
                end if;
              
                if ta_plan_cuen(x).cuco_indi_impu = 'S' then
                  if ta_plan_cuen(x).tipo_sald = 'DB' then
                    v_impo      := v_impo + ta_plan_cuen(x).impo_mmnn;
                    v_impo_mmee := v_impo_mmee + ta_plan_cuen(x).impo_mmee;
                  elsif ta_plan_cuen(x).tipo_sald = 'CR' then
                    v_impo      := v_impo - ta_plan_cuen(x).impo_mmnn;
                    v_impo_mmee := v_impo_mmee - ta_plan_cuen(x).impo_mmee;
                  end if;
                  v_nume_item := ta_plan_cuen(x).nume_item;
                end if;
              end if;
            end if;
            dbms_output.put_line(v_impo || ' - ' || v_cuco_codi);
          end loop;
        
          if v_indi_entro = 'N' then
            if v_impo >= 0 then
              v_tipo_sald := 'DB';
            else
              v_tipo_sald := 'CR';
            end if;
            v_reg := v_reg + 1;
            ta_plan_cuen_resu(v_reg).cuco_codi := v_cuco_codi;
            ta_plan_cuen_resu(v_reg).cuco_nume := v_cuco_nume;
            ta_plan_cuen_resu(v_reg).impo_mmnn := abs(v_impo);
            ta_plan_cuen_resu(v_reg).impo_mmee := abs(v_impo_mmee);
            ta_plan_cuen_resu(v_reg).tipo_sald := v_tipo_sald;
            ta_plan_cuen_resu(v_reg).nume_item := v_nume_item;
            ta_plan_cuen_resu(v_reg).cuco_desc := v_cuco_desc;
            ta_plan_cuen_resu(v_reg).cuco_nive := v_cuco_nive;
            ta_plan_cuen_resu(v_reg).cuco_indi_impu := 'N';
            ta_plan_cuen_resu(v_reg).indi_tota := 'S';
            ta_plan_cuen_resu(v_reg).cuco_nume_orig := v_cuco_nume_orig;
            ta_plan_cuen_resu(v_reg).cuco_tipo_cuen := v_cuco_tipo_cuen;
          end if;
        end if;
      end loop;
    
      if p_tipo = 'AP' then
        for x in 1 .. ta_plan_cuen.count loop
          v_sql_final := ' insert into t_plan_cuen(CUCO_CODI,
                                                              CUCO_NUME,
                                                              IMPO_MMNN,
                                                              TIPO_SALD,
                                                              NUME_ITEM,
                                                              CUCO_DESC,
                                                              CUCO_NIVE,
                                                              CUCO_INDI_IMPU,
                                                              INDI_TOTA,
                                                              CUCO_CUCO_CODI,
                                                              CUCO_NUME_ORIG,
                                                              IMPO_MMEE,
                                                              CUCO_TIPO_CUEN
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
                                                              :13)';
          execute immediate v_sql_final
            using ta_plan_cuen(x).cuco_codi, ta_plan_cuen(x).CUCO_NUME, ta_plan_cuen(x).IMPO_MMNN, ta_plan_cuen(x).TIPO_SALD, ta_plan_cuen(x).NUME_ITEM, ta_plan_cuen(x).CUCO_DESC, ta_plan_cuen(x).CUCO_NIVE, ta_plan_cuen(x).CUCO_INDI_IMPU, ta_plan_cuen(x).INDI_TOTA, ta_plan_cuen(x).CUCO_CUCO_CODI, ta_plan_cuen(x).CUCO_NUME_ORIG, ta_plan_cuen(x).IMPO_MMEE, ta_plan_cuen(x).CUCO_TIPO_CUEN;
        end loop;
      
        for x in 1 .. ta_plan_cuen_resu.COUNT loop
          v_sql_final := ' insert into t_plan_cuen(CUCO_CODI,
                                                              CUCO_NUME,
                                                              IMPO_MMNN,
                                                              TIPO_SALD,
                                                              NUME_ITEM,
                                                              CUCO_DESC,
                                                              CUCO_NIVE,
                                                              CUCO_INDI_IMPU,
                                                              INDI_TOTA,
                                                              CUCO_CUCO_CODI,
                                                              CUCO_NUME_ORIG,
                                                              IMPO_MMEE,
                                                              CUCO_TIPO_CUEN
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
                                                              :13)';
          execute immediate v_sql_final
            using ta_plan_cuen_resu(x).cuco_codi, ta_plan_cuen_resu(x).CUCO_NUME, ta_plan_cuen_resu(x).IMPO_MMNN, ta_plan_cuen_resu(x).TIPO_SALD, ta_plan_cuen_resu(x).NUME_ITEM, ta_plan_cuen_resu(x).CUCO_DESC, ta_plan_cuen_resu(x).CUCO_NIVE, ta_plan_cuen_resu(x).CUCO_INDI_IMPU, ta_plan_cuen_resu(x).INDI_TOTA, ta_plan_cuen_resu(x).CUCO_CUCO_CODI, ta_plan_cuen_resu(x).CUCO_NUME_ORIG, ta_plan_cuen_resu(x).IMPO_MMEE, ta_plan_cuen_resu(x).CUCO_TIPO_CUEN;
        end loop;
        commit;
      
      else
        for x in 1 .. ta_plan_cuen.count loop
          v_sql_final := ' insert into t_plan_cuen_cuad(CUCO_CODI,
                                                                    CUCO_NUME,
                                                                    IMPO_MMNN,
                                                                    TIPO_SALD,
                                                                    NUME_ITEM,
                                                                    CUCO_DESC,
                                                                    CUCO_NIVE,
                                                                    CUCO_INDI_IMPU,
                                                                    INDI_TOTA,
                                                                    CUCO_CUCO_CODI,
                                                                    CUCO_NUME_ORIG,
                                                                    IMPO_MMEE,
                                                                    CUCO_TIPO_CUEN
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
                                                                    :13)';
          execute immediate v_sql_final
            using ta_plan_cuen(x).cuco_codi, ta_plan_cuen(x).CUCO_NUME, ta_plan_cuen(x).IMPO_MMNN, ta_plan_cuen(x).TIPO_SALD, ta_plan_cuen(x).NUME_ITEM, ta_plan_cuen(x).CUCO_DESC, ta_plan_cuen(x).CUCO_NIVE, ta_plan_cuen(x).CUCO_INDI_IMPU, ta_plan_cuen(x).INDI_TOTA, ta_plan_cuen(x).CUCO_CUCO_CODI, ta_plan_cuen(x).CUCO_NUME_ORIG, ta_plan_cuen(x).IMPO_MMEE, ta_plan_cuen(x).CUCO_TIPO_CUEN;
        end loop;
      
        for x in 1 .. ta_plan_cuen_resu.COUNT loop
          v_sql_final := ' insert into t_plan_cuen_cuad(CUCO_CODI,
                                                                    CUCO_NUME,
                                                                    IMPO_MMNN,
                                                                    TIPO_SALD,
                                                                    NUME_ITEM,
                                                                    CUCO_DESC,
                                                                    CUCO_NIVE,
                                                                    CUCO_INDI_IMPU,
                                                                    INDI_TOTA,
                                                                    CUCO_CUCO_CODI,
                                                                    CUCO_NUME_ORIG,
                                                                    IMPO_MMEE,
                                                                    CUCO_TIPO_CUEN
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
                                                                    :13)';
          execute immediate v_sql_final
            using ta_plan_cuen_resu(x).cuco_codi, ta_plan_cuen_resu(x).CUCO_NUME, ta_plan_cuen_resu(x).IMPO_MMNN, ta_plan_cuen_resu(x).TIPO_SALD, ta_plan_cuen_resu(x).NUME_ITEM, ta_plan_cuen_resu(x).CUCO_DESC, ta_plan_cuen_resu(x).CUCO_NIVE, ta_plan_cuen_resu(x).CUCO_INDI_IMPU, ta_plan_cuen_resu(x).INDI_TOTA, ta_plan_cuen_resu(x).CUCO_CUCO_CODI, ta_plan_cuen_resu(x).CUCO_NUME_ORIG, ta_plan_cuen_resu(x).IMPO_MMEE, ta_plan_cuen_resu(x).CUCO_TIPO_CUEN;
        end loop;
        commit;
      end if;
    end if;

  exception
    when tabla_llaveada then
      p_indi := 1;
  end;

  procedure pp_ejecutar_consulta is
    v_cf_impo      number;
    v_cf_tipo_sald varchar2(500);
  
    cursor cur_list is
      select t.cuco_codi,
             replace(t.cuco_nume, chr(32), '-') cuco_nume,
             t.impo_mmnn,
             t.tipo_sald,
             t.nume_item,
             replace(t.cuco_desc, chr(32), '-') cuco_desc,
             t.cuco_nive,
             t.cuco_indi_impu,
             t.indi_tota,
             t.cuco_cuco_codi,
             t.cuco_nume_orig,
             t.impo_mmee,
             t.cuco_tipo_cuen,
             t.cuco_ceco_codi
        from t_plan_cuen t
      --where 1 = 0
      ;
  begin
  
    delete come_tabl_auxi t
     where t.taax_sess = parameter.p_app_session
       and t.taax_user = gen_user;
  
    for c in cur_list loop
  
      if nvl(parameter.p_indi_most_cero, 'N') = 'N' then
        if c.impo_mmnn = 0 then
          continue;
        end if;
      end if;
    
      if c.indi_tota = 'S' or c.cuco_indi_impu = 'S' then
        if parameter.p_mone_codi = parameter.p_codi_mone_mmnn then
          v_cf_impo := c.impo_mmnn;
        else
          v_cf_impo := c.impo_mmee;
        end if;
      else
        v_cf_impo := null;
      end if;
    
      if c.cuco_tipo_cuen = 'A' then
        if c.tipo_sald = 'DB' or nvl(v_cf_impo, 0) = 0 then
          v_cf_tipo_sald := null;
        else
          v_cf_tipo_sald := c.tipo_sald;
        end if;
      end if;
    
      if c.cuco_tipo_cuen = 'P' then
        if c.tipo_sald = 'CR' or nvl(v_cf_impo, 0) = 0 then
          v_cf_tipo_sald := null;
        else
          v_cf_tipo_sald := c.tipo_sald;
        end if;
      end if;
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c004,
         taax_c006,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_c013,
         taax_c014,
         taax_c015,
         taax_c016,
         taax_c017,
         taax_c018,
         taax_c019,
         taax_n003,
         taax_n005,
         taax_n007,
         taax_n012,
         taax_seq)
      values
        (parameter.p_app_session,
         gen_user,
         c.cuco_codi,
         c.cuco_nume,
         v_cf_tipo_sald, ---c.tipo_sald,
         c.cuco_desc,
         c.cuco_indi_impu,
         c.indi_tota,
         c.cuco_cuco_codi,
         c.cuco_nume_orig,
         c.cuco_tipo_cuen,
         parameter.p_ejer_codi,
         parameter.p_ejer_desc,
         parameter.p_mone_codi,
         parameter.p_mone_desc,
         parameter.p_ceco_codi,
         parameter.p_ceco_desc,
         v_cf_impo, -- c.impo_mmnn,
         c.nume_item,
         c.cuco_nive,
         c.impo_mmee,
         seq_come_tabl_auxi.nextval);
    end loop;
  
  end pp_ejecutar_consulta;

  procedure pp_recrea_tabla is
    v_user  varchar2(200) := gen_user;
    v_count number;
  
    v_drop   varchar2(2000);
    v_create varchar2(2000);
  
    v_resu      varchar2(2000);
    v_resu_cuot varchar2(2000);
  begin
  
    pa_ejecuta_ddl('truncate table t_plan_cuen');
    pa_ejecuta_ddl('truncate table t_plan_cuen_cuad');
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_procesar_balance(i_app_session         in number,
                                i_ejer_codi           in number,
                                i_ejer_desc           in varchar2,
                                i_ejer_fech_inic      in date,
                                i_ejer_fech_fini      in date,
                                i_fech_hast           in date default null,
                                i_mone_codi           in number default null,
                                i_mone_desc           in varchar2,
                                i_ceco_codi           in number default null,
                                i_ceco_desc           in varchar2,
                                i_indi_excl_asie_cier in varchar2,
                                i_indi_most_cero      in varchar2) is
    v_indi number;
  begin
  
    parameter.p_app_session    := i_app_session;
    parameter.p_ejer_codi      := i_ejer_codi;
    parameter.p_ejer_desc      := i_ejer_desc;
    parameter.p_mone_codi      := i_mone_codi;
    parameter.p_mone_desc      := i_mone_desc;
    parameter.p_ceco_codi      := i_ceco_codi;
    parameter.p_ceco_desc      := i_ceco_desc;
    parameter.p_indi_most_cero := i_indi_most_cero;
  
    if i_fech_hast is not null then
      if i_fech_hast not between v('P16_EJER_FECH_INIC') and
         v('P16_EJER_FECH_FINI') then
        raise_application_error(-20001,
                                'La fecha no corresponde al Ejercicio Fiscal Seleccionado!!');
      end if;
    end if;
  
    if i_indi_most_cero = 'N' then
      parameter.p_report := 'I040070N';
    else
      parameter.p_report := 'I040070';
    end if;
  
    pp_recrea_tabla;
  
    pa_actu_dife_asie;
    pa_bala_gral_bc(v_indi,
                    'AP',
                    i_ejer_fech_inic,
                    nvl(i_fech_hast, i_ejer_fech_fini),
                    i_ceco_codi,
                    nvl(i_indi_excl_asie_cier, 'N'));
  
    if v_indi = 1 then
      raise_application_error(-20001,
                              'En este momento el Balance esta siendo generado por otro Usuario, favor aguarde!!');
    elsif v_indi = 2 then
      raise_application_error(-20002,
                              'Alguna cuenta no imputable tiene saldo, favor verifique!!');
    end if;
  
    pp_ejecutar_consulta;
    pp_llama_reporte;
  exception
    when others then
      pl_me(sqlerrm);
  end pp_procesar_balance;

  procedure pp_post_query is
  begin
    null;
    /*if :indi_tota = 'S' or :bdatos.cuco_indi_impu = 'S' then
      if :bsel.mone_codi = :parameter.p_codi_mone_mmnn then
        :bdatos.cf_impo := :bdatos.impo_mmnn;
      else
        :bdatos.cf_impo := :bdatos.impo_mmee;
      end if;
    else
      :bdatos.cf_impo := null;
    end if;
    
    if :cuco_tipo_cuen = 'A' then
      if :tipo_sald = 'DB' or nvl(:bdatos.cf_impo, 0) = 0 then
        :cf_tipo_sald := null;
      else
        :cf_tipo_sald := :tipo_sald;
      end if;
    end if;
    
    if :cuco_tipo_cuen = 'P' then
      if :tipo_sald = 'CR' or nvl(:bdatos.cf_impo, 0) = 0 then
        :cf_tipo_sald := null;
      else
        :cf_tipo_sald := :tipo_sald;
      end if;
    end if;*/
  end;

end i040070;
