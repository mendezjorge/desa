
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010017" is

  PROCEDURE pp_encripta_pass(P_pass in varchar2, p_user_codi in varchar2) IS
    v_spass varchar2(32);
    v_upass varchar2(40);
  BEGIN
    pa_encripta_pass(p_pass, v_spass, v_upass);
    update segu_user
       set USER_SPASS = v_spass, user_upass = v_upass
     where user_codi = p_user_codi;
    commit;
  END;

  -----------------------------------------------------------------------------------------------------------

  PROCEDURE PP_ACTUALIZAR_REGISTRO(p_USU_PASS  in varchar2,
                                   p_PASS2     in varchar2,
                                   p_user_codi in varchar2) IS
    v_user          varchar2(20);
    v_pass          varchar2(20) := p_pass2;
    v_pass_apex     varchar2(100); -- variable para almacenar la contrase?a encriptada
    p_indi_apex     varchar2(100);
    p_indi_app_movi varchar(100);
    p_usu_login     varchar2(100);

  BEGIN

    select user_login
      into p_usu_login
      from segu_user
     where user_codi = p_user_codi;

    v_user := p_usu_login;

    p_indi_apex     := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_apex')));
    p_indi_app_movi := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_app_movi')));

    if p_USU_PASS <> p_PASS2 THEN
      raise_application_error(-20001, 'Vuelva a Confirmar Contrasenha');
    end if;

    PA_EJECUTA_DDL('ALTER USER ' || v_USER || ' IDENTIFIED BY ' || v_PASS);

    if nvl(p_indi_app_movi, 'N') = 'S' then
      pp_encripta_pass(p_usu_pass, p_user_codi);
    end if;

    -- actulizar la tabla como_segu para encriptar la contrase?a

    if nvl(p_indi_apex, 'N') = 'S' then
      v_pass_apex := my_hash(p_usu_login, p_usu_pass);

      update segu_user
         set user_pass = v_pass_apex --actualizacion en la tabla segu_user
       where user_login = p_usu_login;
      commit;
    end if;
    apex_application.g_print_success_message := 'La Contrasenha se cambio con exito';
  END;
end I010017;
