
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I030010_A" is

  -- Private type declarations
    type r_parameter is record (
         collection_name       varchar2(30):='CUENTAS_DET'
    );
    parameter r_parameter;


  -----------------------------------------------
   procedure pp_validar_moneda(i_mone_codi in number,
                              o_mone_desc out varchar2,
                              o_mone_desc_abre out varchar2,
                              o_mone_cant_deci out number)is
    begin

     --raise_application_error(-20010,'i_mone_codi:'||i_mone_codi);

      if i_mone_codi is null then
        o_mone_desc       := 'Consolidado en moneda Nacional';
        o_mone_desc_abre  :=  general_skn.fl_busca_parametro('p_mone_desc_abre_mmnn');
        o_mone_cant_deci  :=  to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn'));

      else
        general_skn.pl_muestra_come_mone(i_mone_codi,o_mone_desc,o_mone_desc_abre,o_mone_cant_deci);
      end if;

    end pp_validar_moneda;
  -----------------------------------------------
    procedure pp_ejecutar_consulta(i_mone_codi      in number,
                                 i_indi_caja_banc in varchar2,
                                 i_cuco_codi      in varchar2,
                                 i_fech_inic      in date,
                                 i_fech_fini      in date,
                                 o_indi_prin      out varchar2
                                 ) is

      TYPE tr_cuen_banc IS RECORD(
        cuen_codi      number,
        cuen_desc      VARCHAR2(50),
        mone_desc_abre VARCHAR2(50));

      TYPE tt_cuen_banc IS TABLE OF tr_cuen_banc INDEX BY BINARY_INTEGER;
      ta_cuen_banc tt_cuen_banc;

      v_cant_regi number := 0;
      v_cred      number;
      v_debi      number;
      v_sald_fini number;
      v_sald_inic number;
      x           number := 0;

    begin

      --primero cargar todas las cuentas bancarias existentes en el bloque bdatos
      select cuen_codi, cuen_desc, mone_desc_abre
        BULK COLLECT
        INTO ta_cuen_banc
        from come_cuen_banc, come_mone, segu_user_cuen_banc s, segu_user u
       where mone_codi = cuen_mone_codi
         and cuen_codi = uscb_cuen_codi
         and s.uscb_user_codi = u.user_codi
         and u.user_login = gen_user
         and (i_mone_codi is null or cuen_mone_codi = i_mone_codi)
            --and ((i_indi_caja_banc = 'C' and cuen_banc_codi is null) or (i_indi_caja_banc = 'B' and cuen_banc_codi is not null) or (i_indi_caja_banc = 'T'))
         and (cuen_indi_caja_banc = i_indi_caja_banc or i_indi_caja_banc = 'T')
         and (cuen_efec_cuco_codi = i_cuco_codi or i_cuco_codi is null)
       group by cuen_codi, cuen_desc, mone_desc_abre
       order by cuen_codi;

      v_cant_regi := ta_cuen_banc.count;


      if i_mone_codi is not null then

        for x in 1 .. v_cant_regi loop
          --saldo inicial...........
          select nvl(sum(sald_inic_mone), 0) sald_inic_mone
            into v_sald_inic
            from come_cuen_banc_sald
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech = i_fech_inic;

          --saldo debito y credito
          select nvl(sum(sald_debi_mone), 0), nvl(sum(sald_cred_mone), 0)
            into v_debi, v_cred
            from come_cuen_banc_sald
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech between nvl(i_fech_inic, '01-01-1000') and
                 i_fech_fini;

          --saldo final...........
          v_sald_fini := nvl(v_sald_inic, 0) + nvl(v_debi, 0) - nvl(v_cred, 0);


          pack_mane_tabl_auxi.pp_add_members(i_taax_sess            => v('APP_SESSION'),
                                   i_taax_user            => gen_user,
                                   i_taax_c001            => ta_cuen_banc(x).cuen_codi,
                                    i_taax_c002            => ta_cuen_banc(x).cuen_desc,
                                    i_taax_c003            => ta_cuen_banc(x).mone_desc_abre,
                                    i_taax_c004            => v_sald_inic,
                                    i_taax_c005            => v_debi,
                                    i_taax_c006            => v_cred,
                                    i_taax_c007            => v_sald_fini
                                    );
        end loop;

      else
        ---consolidado en moneda Nacional
        for x in 1 .. v_cant_regi loop

          --saldo inicial...........
          select nvl(sum(sald_inic_mmnn), 0) sald_inic_mmnn
            into v_sald_inic
            from come_cuen_banc_sald
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech = i_fech_inic;

          --saldo debito y credito
          select nvl(sum(sald_debi_mmnn), 0), nvl(sum(sald_cred_mmnn), 0)
            into v_debi, v_cred
            from come_cuen_banc_sald
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech between nvl(i_fech_inic, '01-01-1000') and
                 i_fech_fini;

          --saldo final...........
          v_sald_fini := nvl(v_sald_inic, 0) + nvl(v_debi, 0) - nvl(v_cred, 0);

          pack_mane_tabl_auxi.pp_add_members(i_taax_sess            => v('APP_SESSION'),
                         i_taax_user            => gen_user,
                         i_taax_c001            => ta_cuen_banc(x).cuen_codi,
                          i_taax_c002            => ta_cuen_banc(x).cuen_desc,
                          i_taax_c003            => ta_cuen_banc(x).mone_desc_abre,
                          i_taax_c004            => v_sald_inic,
                          i_taax_c005            => v_debi,
                          i_taax_c006            => v_cred,
                          i_taax_c007            => v_sald_fini
                          );

        end loop;



      end if;

      o_indi_prin:= 'S';


    end pp_ejecutar_consulta;

  -----------------------------------------------
    procedure pp_ejecutar_consulta_oper(i_mone_codi in number,
                                     i_indi_caja_banc in varchar2,
                                     i_cuco_codi      in number,
                                     i_fech_inic      in date,
                                     i_fech_fini      in date,
                                     o_indi_prin      out varchar2
                                     ) is


    TYPE tr_cuen_banc IS RECORD(
        cuen_codi      number,
        cuen_desc      VARCHAR2(50),
        mone_desc_abre VARCHAR2(50));

    TYPE tt_cuen_banc IS TABLE OF tr_cuen_banc INDEX BY BINARY_INTEGER;
    ta_cuen_banc tt_cuen_banc;

    v_cred      number;
    v_cant_regi number;
    v_debi      number;
    v_sald_fini number;
    v_sald_inic number;
    x           number := 0;

    begin

      --primero cargar todas las cuentas bancarias existentes en el bloque bdatos
      --cursor c_cuen_banc is
        select cuen_codi, cuen_desc, mone_desc_abre
          BULK COLLECT INTO ta_cuen_banc
          from come_cuen_banc, come_mone, segu_user_cuen_banc s, segu_user u
         where mone_codi = cuen_mone_codi
           and cuen_codi = uscb_cuen_codi
           and s.uscb_user_codi = u.user_codi
           and u.user_login = user
           and (i_mone_codi is null or cuen_mone_codi = i_mone_codi)
              --and ((i_indi_caja_banc = 'C' and cuen_banc_codi is null) or (i_indi_caja_banc = 'B' and cuen_banc_codi is not null) or (i_indi_caja_banc = 'T'))
           and (cuen_indi_caja_banc = i_indi_caja_banc or
               i_indi_caja_banc = 'T')
           and (cuen_efec_cuco_codi = i_cuco_codi or
               i_cuco_codi is null)
         group by cuen_codi, cuen_desc, mone_desc_abre
         order by cuen_codi;


      /*
      for x in c_cuen_banc loop
        create_Record;
        ta_cuen_banc(x).cuen_codi      := x.cuen_codi;
        :bdatos.cuen_desc      := x.cuen_desc;
        :bdatos.mone_desc_abre := x.mone_desc_abre;
      end loop;
      */

      v_cant_regi := ta_cuen_banc.count;

      if i_mone_codi is not null then

        for x in 1 .. v_cant_regi loop
        --loop
          --saldo inicial...........
          select nvl(sum(sald_inic_mone), 0) sald_inic_mone
            into v_sald_inic
            from come_cuen_banc_sald_oper
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech = i_fech_inic;

          --saldo debito y credito
          select nvl(sum(sald_debi_mone), 0), nvl(sum(sald_cred_mone), 0)
            into v_debi, v_cred
            from come_cuen_banc_sald_oper
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech between nvl(i_fech_inic, '01-01-1000') and
                 i_fech_fini;

          --saldo final...........
          v_sald_fini := nvl(v_sald_inic, 0) + nvl(v_debi, 0) - nvl(v_cred, 0);

          pack_mane_tabl_auxi.pp_add_members(i_taax_sess            => v('APP_SESSION'),
                         i_taax_user            => gen_user,
                         i_taax_c001            => ta_cuen_banc(x).cuen_codi,
                          i_taax_c002            => ta_cuen_banc(x).cuen_desc,
                          i_taax_c003            => ta_cuen_banc(x).mone_desc_abre,
                          i_taax_c004            => v_sald_inic,
                          i_taax_c005            => v_debi,
                          i_taax_c006            => v_cred,
                          i_taax_c007            => v_sald_fini
                          );

        end loop;

      else
        ---consolidado en moneda Nacional
        for x in 1 .. v_cant_regi loop
        --loop
          --saldo inicial...........
          select nvl(sum(sald_inic_mmnn), 0) sald_inic_mmnn
            into v_sald_inic
            from come_cuen_banc_sald_oper
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech = i_fech_inic;

          --saldo debito y credito
          select nvl(sum(sald_debi_mmnn), 0), nvl(sum(sald_cred_mmnn), 0)
            into v_debi, v_cred
            from come_cuen_banc_sald_oper
           where sald_cuen_codi = ta_cuen_banc(x).cuen_codi
             and sald_fech between nvl(i_fech_inic, '01-01-1000') and
                 i_fech_fini;

          --saldo final...........
          v_sald_fini := nvl(v_sald_inic, 0) + nvl(v_debi, 0) - nvl(v_cred, 0);

          pack_mane_tabl_auxi.pp_add_members(i_taax_sess            => v('APP_SESSION'),
                         i_taax_user            => gen_user,
                         i_taax_c001            => ta_cuen_banc(x).cuen_codi,
                          i_taax_c002            => ta_cuen_banc(x).cuen_desc,
                          i_taax_c003            => ta_cuen_banc(x).mone_desc_abre,
                          i_taax_c004            => v_sald_inic,
                          i_taax_c005            => v_debi,
                          i_taax_c006            => v_cred,
                          i_taax_c007            => v_sald_fini
                          );
        end loop;

      end if;

      o_indi_prin:= 'S';

    end pp_ejecutar_consulta_oper;

  -----------------------------------------------
    procedure pp_muestra_come_cuen_cont(p_nume in varchar2,
                                        p_desc out varchar2,
                                        p_codi out varchar2) is

    v_indi_impu varchar2(50);

    begin



      select cuco_codi, cuco_indi_impu, cuco_desc
        into p_codi, v_indi_impu, p_desc
        from come_cuen_cont
       where cuco_nume = p_nume;



      if nvl(v_indi_impu, 'N') <> 'S' then
        raise_application_error(-20010,'Debe ingresar solamente las cuentas contables que se encuentren imputables !!!');
      end if;

--      raise_application_error(-20010,'p_nume: '||p_nume);

    exception
      when no_data_found then
        raise_application_error(-20010,'Cuenta Contable inexistente!');
      when others then
        raise_application_error(-20010,'Error al buscar la Cuenta Contable!. '||sqlerrm);

    end pp_muestra_come_cuen_cont;

  -----------------------------------------------
    procedure pp_validar_nulos (i_tipo in varchar2,
                               i_mone_codi      in number,
                               i_indi_caja_banc in varchar2,
                               i_fech_inic      in date,
                               i_fech_fini      in date) is

    begin
      if i_tipo is null then
        raise_application_error(-20010,'Debe de elegir un Tipo de fecha!');
      end if;

      if i_indi_caja_banc is null then
        raise_application_error(-20010,'Debe de elegir una caja determinada!');
      end if;

      if i_fech_inic is null then
        raise_application_error(-20010,'Debe de ingresar la fecha de inicio!');
      end if;

      if i_fech_fini is null then
        raise_application_error(-20010,'Debe de ingresar la fecha de finalizacion!');
      end if;


    end pp_validar_nulos;
  -----------------------------------------------
    procedure pp_call_consulta(i_tipo in varchar2,
                               i_mone_codi      in number,
                               i_indi_caja_banc in varchar2,
                               i_cuco_codi      in varchar2,
                               i_fech_inic      in date,
                               i_fech_fini      in date,
                               o_indi_prin      out varchar2
                               ) is

       v_mone_codi number;

    begin

      if i_mone_codi is null then
        v_mone_codi:=1;
      else
        v_mone_codi:=i_mone_codi;
      end if;

      pp_validar_nulos (i_tipo,
                         i_mone_codi,
                         i_indi_caja_banc,
                         i_fech_inic,
                         i_fech_fini);

      if i_tipo = 'D' then
        --
        pp_ejecutar_consulta(i_mone_codi,
                             i_indi_caja_banc,
                             i_cuco_codi,
                             i_fech_inic,
                             i_fech_fini,
                             o_indi_prin);

        -- raise_application_error(-20010,'o_indi_prin: '||o_indi_prin);
      else
        --
         pp_ejecutar_consulta_oper(i_mone_codi,
                                   i_indi_caja_banc,
                                   i_cuco_codi,
                                   i_fech_inic,
                                   i_fech_fini,
                                   o_indi_prin);
      end if;

    end pp_call_consulta;
  -----------------------------------------------
    procedure pp_imprimir_reportes (i_fech_inic in date,
                                    i_fech_fini in date,
                                    i_empr_desc in varchar2,
                                    i_mone_codi in number,
                                    i_mone_desc in varchar2,
                                    i_cuen_indi_caja_banc_desc in varchar2,
                                    i_cuco_codi in varchar2,
                                    i_cuco_desc_efec in varchar2,
                                    i_cuco_nume_efec in varchar2) is

    v_report       VARCHAR2(50);
    v_parametros   CLOB;
    v_contenedores CLOB;

    p_cuen_indi_caja_banc_desc varchar2(50);
    p_where varchar2(500);

    v_mone_codi number;


    begin

      if i_fech_inic is null then
        raise_application_error(-20010,'Debe ingresar la fecha desde');
      end if;

      if i_fech_fini is  null then
        raise_application_error(-20010,'Debe ingresar la fecha hasta');
      end if;

      if i_mone_codi is not null then
        v_mone_codi:= i_mone_codi;
      else
        v_mone_codi:= 1;
      end if;

      --raise_application_error(-20010,'p_where:'||p_where);

      case i_cuen_indi_caja_banc_desc
        when 'T' then
          p_cuen_indi_caja_banc_desc:= 'Todos';
        when 'B' then
          p_cuen_indi_caja_banc_desc:= 'Bancos';
        when 'C' then
          p_cuen_indi_caja_banc_desc:= 'Cajas';
      end case;

      V_CONTENEDORES := 'p_fech_inic:p_fech_fini:p_empr_desc:p_user:p_session:p_mone_codi:p_mone_desc:p_cuen_indi_caja_banc_desc:p_cuco_nume:p_cuco_desc_efec';


      V_PARAMETROS   :=   i_fech_inic || ':' ||
                          i_fech_fini || ':' ||
                          i_empr_desc || ':' ||
                           gen_user|| ':' ||
                           v('APP_SESSION')|| ':' ||
                          v_mone_codi || ':' ||
                          i_mone_desc || ':' ||
                          p_cuen_indi_caja_banc_desc || ':' ||
                          i_cuco_nume_efec || ':' ||
                          i_cuco_desc_efec

                          ;

      v_report       :='I030010MB';

      DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

      INSERT INTO COME_PARAMETROS_REPORT
        (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
      VALUES
        (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

      commit;
    end pp_imprimir_reportes;

-----------------------------------------------
   procedure pp_validar_perfil(indi_pagi out number) is

    v_user varchar2(50);
    v_cant number:=100;

  begin

    v_user:= gen_user;

      select count(*)
      into v_cant
      from segu_user u, SEGU_PANT_PERF p, segu_user_perf
      where p.pape_perf_codi = u.USER_PERF_CODI
      and   p.pape_base      = u.user_base
      and   u.user_login     = v_user
      and   p.pape_pant_codi = 108;--es el codigo de la pagina de segu_pant(Consulta de documentos)

      if v_cant = 0 then
        select count(*)
         into v_cant
        from SEGU_PANT_PERF p, (select user_codi, user_base, user_desc, f.uspe_perf_codi
                                from segu_user u, segu_user_perf f
                                where u.user_login     = gen_user
                                  and uspe_user_codi = user_codi
                                  and uspe_base = user_base) c
        where p.pape_perf_codi = c.uspe_perf_codi
        and   p.pape_base      = c.user_base
        and   p.pape_pant_codi = 108;

      end if;

    indi_pagi:=v_cant;

    indi_pagi:=1;

  end pp_validar_perfil;
-----------------------------------------------

end I030010_A;
